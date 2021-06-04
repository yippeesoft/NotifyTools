#include <stdio.h>
#include <string.h> 
int main() {

  FILE *fp0 = NULL;

  char Buf[4096];

  /*初始化Buf*/
  printf("hello mytest !");
  strcpy(Buf, "Mem is char dev!");

  printf("BUF: %s\n", Buf);

  /*打开设备文件*/

  fp0 = fopen("/dev/demo", "r+");

  if (fp0 == NULL)

  {

    printf("Open Memdev0 Error!\n");

    return -1;
  }

  /*写入设备*/

  fwrite(Buf, sizeof(Buf), 1, fp0);

  /*重新定位文件位置（思考没有该指令，会有何后果)*/

  fseek(fp0, 0, SEEK_SET);

  /*清除Buf*/

  strcpy(Buf, "Buf is NULL!");

  printf("BUF: %s\n", Buf);

  /*读出设备*/

  fread(Buf, sizeof(Buf), 1, fp0);

  /*检测结果*/

  printf("BUF: %s\n", Buf);

  return 0;
}