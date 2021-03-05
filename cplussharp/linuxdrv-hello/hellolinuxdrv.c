// https://blog.csdn.net/myz348/article/details/104884865

#include <linux/module.h>
 
 static int __init hello_init(void){
    printk(KERN_INFO"hello world init !\n");
     return 0;
  }
  static void __exit hello_exit(void){
     printk(KERN_INFO"hello world exit !\n");
 }
 
 module_init(hello_init);
 module_exit(hello_exit);
 MODULE_LICENSE("GPL");
// ————————————————
// 版权声明：本文为CSDN博主「myz348」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
// 原文链接：https://blog.csdn.net/myz348/article/details/104884865
