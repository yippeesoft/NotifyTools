// https://blog.csdn.net/myz348/article/details/104884865

#include <linux/miscdevice.h>    
#include <linux/delay.h>    
#include <asm/irq.h>
#include <linux/kernel.h>    
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/unistd.h>
#include <linux/string.h>
#include <linux/fcntl.h>
#include <asm/uaccess.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/version.h>
 
#include <linux/kernel.h>
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <linux/device.h>    

// ssize_t(*read) (struct file *, char __user *, size_t, loff_t *);
ssize_t Hello_read(struct file* filp, char __user * buf, size_t count, loff_t * offset)
{
    printk("enter cdd_open!\n");
    return 0;
}
// ssize_t(*write) (struct file *, const char __user *, size_t, loff_t *);
ssize_t Hello_write(struct file* filp, const char __user* buf, size_t count, loff_t* offset)
{
    printk("enter cdd_write!\n");
    return 0;
}

static struct file_operations io_dev_fops = {
    .owner = THIS_MODULE,
    .read = Hello_read,
    .write = Hello_write,
};

static int __init hello_init(void)
{
    register_chrdev(123, "Hello", &io_dev_fops);
    printk(KERN_INFO "hello world init !\n");
    return 0;
}
static void __exit hello_exit(void)
{
    unregister_chrdev(123, "Hello");
    printk(KERN_INFO "hello world exit !\n");
}

module_init(hello_init);
module_exit(hello_exit);
MODULE_LICENSE("GPL");
// ————————————————
// https://www.bilibili.com/read/cv7241587/ 

// ————————————————
// 版权声明：本文为CSDN博主「毛毛虫的爹」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
// 原文链接：https://blog.csdn.net/mao0514/article/details/9410795
// READ WRITE 参考，但是函数不匹配，会  initialization from incompatible pointer type
