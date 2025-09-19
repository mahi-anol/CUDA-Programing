#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void test01()
{
    printf("The block id is %d --- The thread id is %d\n", blockIdx.x, threadIdx.x);
}

int main()
{
    // Launch 1 block with 1 thread
    test01<<<1,4>>>();


    return 0;
}