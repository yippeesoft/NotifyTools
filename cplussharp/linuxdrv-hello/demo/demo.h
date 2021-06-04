#ifndef _FAKE_REG_H_
#define _FAKE_REG_H_

#include <linux/cdev.h>
#include <linux/semaphore.h>

#define DEMO_DEVICE_NODE_NAME  "demo"
#define DEMO_DEVICE_FILE_NAME  "demo"
#define DEMO_DEVICE_PROC_NAME  "demo"
#define DEMO_DEVICE_CLASS_NAME "demo"

struct fake_reg_dev {
    int val;
    struct semaphore sem;//信号量
    struct cdev dev;
};

#endif