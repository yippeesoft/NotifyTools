#include <linux/init.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/proc_fs.h>
#include <linux/device.h>
#include <linux/slab.h>
#include <linux/seq_file.h>
#include <asm/uaccess.h>

#include "demo.h"

static int demo_major = 0;
static int demo_minor = 0;

static struct class* demo_class = NULL;
static struct fake_reg_dev* demo_dev = NULL;

static int demo_open(struct inode* inode, struct file* filp);
static int demo_release(struct inode* inode, struct file* filp);
static ssize_t demo_read(struct file* filp, char __user *buf, size_t count, loff_t* f_pos);
static ssize_t demo_write(struct file* filp, const char __user *buf, size_t count, loff_t* f_pos);

static struct file_operations demo_fops = {
    .owner = THIS_MODULE,
    .open = demo_open,
    .release = demo_release,
    .read = demo_read,
    .write = demo_write,
};

#define SEQ_printf(m, x...)     \
    do {                \
        if (m)          \
            seq_printf(m, x);   \
        else            \
            pr_err(x);      \
    } while (0)

static int demo_proc_show(struct seq_file *m, void *v)
{
    SEQ_printf(m, "%d\n", demo_dev->val);
    return 0;
}

static int demo_proc_open(struct inode *inode, struct file *file)
{
    return single_open(file, demo_proc_show, inode->i_private);
}

static ssize_t __demo_set_val(struct fake_reg_dev* dev, const char* buf, size_t count){
    int val = 0;

    val = simple_strtol(buf, NULL, 10);

    if(down_interruptible(&(dev->sem))){
        return -ERESTARTSYS;
    }

    dev->val = val;
    up(&(dev->sem));

    return count;
}

/*
static ssize_t demo_proc_read(char* page, char** start, off_t off, int count, int* eof, void* data){
    if(off >0 ){
        *eof = 1;
        return 0;
    }

    return __demo_get_val(demo_dev, page);
}*/

static ssize_t demo_proc_write(struct file *filp, const char *ubuf, size_t cnt, loff_t *data){
    int err = 0;
    char* page = NULL;

    if(cnt > PAGE_SIZE){
        printk(KERN_ALERT"The buff is too large: %lu.\n", cnt);
        return -EFAULT;
    }

    page = (char*) __get_free_page(GFP_KERNEL);
    if(!page){
        printk(KERN_ALERT"Failed to alloc page.\n");
        return -ENOMEM;
    }

    if(copy_from_user(page, ubuf, cnt)){
        printk(KERN_ALERT"Failed to copy buff from user.\n");
        err = -EFAULT;
        goto out;
    }

    err = __demo_set_val(demo_dev, page, cnt);

out:
    free_page((unsigned long)page);
    return err;
}

static const struct file_operations demo_proc_fops = {
    .open = demo_proc_open,
    .write = demo_proc_write,
    .read = seq_read,
    .llseek = seq_lseek,
    .release = single_release,
};


static ssize_t demo_val_show(struct device* dev, struct device_attribute* attr, char* buf);
static ssize_t demo_val_store(struct device* dev, struct device_attribute* attr, const char* buf, size_t count);

static DEVICE_ATTR(val, S_IRUGO | S_IWUSR, demo_val_show, demo_val_store);

static int demo_open(struct inode * inode, struct file * filp){
    struct fake_reg_dev * dev;

    dev = container_of(inode->i_cdev, struct fake_reg_dev, dev);
    filp->private_data = dev;

    return 0;
}

static int demo_release(struct inode* inode, struct file* filp){
    return 0;
}

static ssize_t demo_read(struct file* filp, char __user *buf, size_t count, loff_t* f_pos){
    ssize_t err = 0;
    struct fake_reg_dev* dev = filp->private_data;

    if(down_interruptible(&(dev->sem))){
        return -ERESTARTSYS;
    }

    if(count < sizeof(dev->val)){
        goto out;
    }

    if(copy_to_user(buf, &(dev->val), sizeof(dev->val))){
        err = -EFAULT;
        goto out;
    }

    err = sizeof(dev->val);

out:
    up(&(dev->sem));
    return err;
}

static ssize_t demo_write(struct file * filp, const char __user * buf, size_t count, loff_t * f_pos){
    struct fake_reg_dev* dev = filp->private_data;
    ssize_t err = 0;

    if(down_interruptible(&(dev->sem))){//获取信号量
        return -ERESTARTSYS;
    }

    if(count != sizeof(dev->val)){
        goto out;
    }

    if(copy_from_user(&(dev->val), buf, count)){
        err = -EFAULT;
        goto out;
    }

    err = sizeof(dev->val);

out:
    up(&(dev->sem));//唤醒进程
    return err;
}

static ssize_t __demo_get_val(struct fake_reg_dev* dev, char* buf){
    int val = 0;

    if(down_interruptible(&dev->sem)){
        return -ERESTARTSYS;
    }

    val = dev->val;
    up(&(dev->sem));

    return snprintf(buf, PAGE_SIZE, "%d\n", val);
}


static ssize_t demo_val_show(struct device* dev, struct device_attribute* attr, char* buf){
    struct fake_reg_dev* hdev = (struct fake_reg_dev*)dev_get_drvdata(dev);

    return __demo_get_val(hdev, buf);
}

static ssize_t demo_val_store(struct device*dev, struct device_attribute* attr, const char* buf, size_t count){
    struct fake_reg_dev* hdev = (struct fake_reg_dev*)dev_get_drvdata(dev);

    return __demo_set_val(hdev, buf, count);
}


static void demo_create_proc(void){
    proc_create(DEMO_DEVICE_PROC_NAME, 0644, 0,  &demo_proc_fops);
}

static void demo_remove_proc(void){
    remove_proc_entry(DEMO_DEVICE_PROC_NAME, NULL);
}

static int __demo_setup_dev(struct fake_reg_dev* dev){
    int err;
    dev_t devno = MKDEV(demo_major, demo_minor);

    memset(dev, 0, sizeof(struct fake_reg_dev));

    cdev_init(&(dev->dev), &demo_fops);//初始化dev，绑定对应的fops函数
    dev->dev.owner = THIS_MODULE;
    dev->dev.ops = &demo_fops;

    err = cdev_add(&(dev->dev), devno, 1);//注册设备
    if(err){
        return err;
    }

    //init_MUTEX(&(dev->sem));
    sema_init(&(dev->sem), 1);//初始化信号量为互斥量
    dev->val = 0;

    return 0;
}

static int __init demo_init(void){
    int err = -1;
    dev_t dev = 0;
    struct device* temp = NULL;

    printk(KERN_ALERT"Initializing demo device.\n");

    err = alloc_chrdev_region(&dev, 0, 1, DEMO_DEVICE_NODE_NAME);//动态申请设备号，放入dev中
    if(err < 0){
        printk(KERN_ALERT"Failed to alloc char dev region.\n");
        goto fail;
    }

    demo_major = MAJOR(dev);//得到主设备号
    demo_minor = MINOR(dev);//得到次设备号

    demo_dev = kmalloc(sizeof(struct fake_reg_dev), GFP_KERNEL);//为结构体fake_reg_dev分配内核空间
    if(!demo_dev){
        err = -ENOMEM;
        printk(KERN_ALERT"Failed to alloc demo device.\n");
        goto unregister;
    }

    err = __demo_setup_dev(demo_dev);//cdev_init，cdev_add
    if(err){
        printk(KERN_ALERT"Failed to setup demo device: %d.\n", err);
        goto cleanup;
    }

    demo_class = class_create(THIS_MODULE, DEMO_DEVICE_CLASS_NAME);//创建class并将class注册到内核中
    if(IS_ERR(demo_class)){
        err = PTR_ERR(demo_class);
        printk(KERN_ALERT"Failed to create demo device class.\n");
        goto destroy_cdev;
    }

    temp = device_create(demo_class, NULL, dev, NULL, "%s", DEMO_DEVICE_FILE_NAME);//在/dev目录下生成demo的设备文件
    if(IS_ERR(temp)){
        err = PTR_ERR(temp);
        printk(KERN_ALERT"Failed to create demo device.\n");
        goto destroy_class;
    }

    err = device_create_file(temp, &dev_attr_val);//在/sys/class/xxx/xxx目录下创建属性文件val
    if(err < 0){
        printk(KERN_ALERT"Failed to create attribute val of demo device.\n");
        goto destroy_device;
    }

    dev_set_drvdata(temp, demo_dev);

    demo_create_proc();

    printk(KERN_ALERT"Succedded to initialize demo device.\n");

    return 0;

destroy_device:
    device_destroy(demo_class, dev);
destroy_class:
    class_destroy(demo_class);
destroy_cdev:
    cdev_del(&(demo_dev->dev));
cleanup:
    kfree(demo_dev);
unregister:
    unregister_chrdev_region(MKDEV(demo_major, demo_minor), 1);
fail:
    return err;
}

static void __exit demo_exit(void){
    dev_t devno = MKDEV(demo_major, demo_minor);

    printk(KERN_ALERT"Destory demo device.\n");

    demo_remove_proc();

    if(demo_class){
        device_destroy(demo_class, MKDEV(demo_major, demo_minor));
        class_destroy(demo_class);
    }

    if(demo_dev){
        cdev_del(&(demo_dev->dev));
        kfree(demo_dev);
    }

    unregister_chrdev_region(devno, 1);
}

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Fake Register Driver");

module_init(demo_init);
module_exit(demo_exit);