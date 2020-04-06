#include<cuda.h>
#include<cuda_runtime.h>
#include<stdio.h>



int main()
{
    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, dev);
        printf("%d.%d\n", deviceProp.major, deviceProp.minor);
return 0;
    }