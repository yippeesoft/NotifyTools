#include "stdio.h"
#include <stdlib.h>
unsigned char* testbytes(unsigned char* in, int lenn)
{
    unsigned char* out = (unsigned char*)malloc(lenn);
    for (int i = 0; i < lenn; i++)
    {
        out[i] = in[i] - 1;
    }
    return out;
}

void printt(unsigned char* in, int l)
{
    printf("printt bbb\n");
    for (int i = 0; i < l; i++)
    {
        printf("%0x\t", in[i]);
    }
    printf("printt ddd\n");
}

//gcc testso.c -o test -> exe
//gcc testso.c  -fPIC -shared -o libtest.so
void main()
{
    unsigned char testc[] = {0x0, 0x1, 0x2, 0x3, 0x4};
    printt(testbytes(testc, 5), 5);
}