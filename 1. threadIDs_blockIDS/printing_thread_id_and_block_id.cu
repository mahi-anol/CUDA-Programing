#include <iostream>
#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void kernel()
{
  // print the block ids and thread ids.
  printf("\nThe block id is %d----The thread id is %d\n",blockIdx.x,threadIdx.x);
}
int main()
{
  // PARAMS: (num_of_blk,no_of_thread)
  kernel<<<1,512>>>();
  cudaDeviceSynchronize();
  return 0;
}
