#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void test01()
{
    int warp_ID_Value=0;
    warp_ID_Value=threadIdx.x/32;

    printf("The block id is %d --- The thread id is %d --The wardID %d\n", blockIdx.x, threadIdx.x,warp_ID_Value);
}

int main()
{
    // Launch 1 block with 1 thread
    test01<<<1,4>>>();


    return 0;
}