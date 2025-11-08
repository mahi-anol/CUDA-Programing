#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define SIZE 2048 // defining vector size 

// CUDA kernel vector addition.
__global__ void vectorAdd(int* A,int* B,int* C,int n){
    int i=threadIdx.x+blockIdx.x*blockDim.x; //blockDim= number of thread per block.
    C[i]=A[i]+B[i];
}
int main()
{   ///Adding two vector of size 1024

    // Index size for vector.
    int size=SIZE*sizeof(int);

    // Allocating cpu memory
    int* A ,* B,* C;
    A=(int*)malloc(size);
    B=(int*)malloc(size);
    C=(int*)malloc(size);

    // Allocating Device memeory
    int* dA,* dB,* dC;
    cudaMalloc((void**)&dA,size);
    cudaMalloc((void**)&dB,size);
    cudaMalloc((void**)&dC,size);

    // assigning input
    for(int i=0;i<SIZE;i++){
        A[i]=i;
        B[i]=SIZE-i;
    }

    cudaMemcpy(dA,A,size,cudaMemcpyHostToDevice);
    cudaMemcpy(dB,B,size,cudaMemcpyHostToDevice);

    // Lunching the kernel
    vectorAdd<<<2,1024>>>(dA,dB,dC,SIZE);
    cudaDeviceSynchronize();



    //copy result back to host.
    cudaMemcpy(C,dC,size,cudaMemcpyDeviceToHost);
    printf("\nExecution finished\n");

    for(int i=0;i<SIZE;i++)
    {
        printf("%d + %d = %d",A[i],B[i],C[i]);
        printf("\n");
    }

    // Cleaning memory
    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);
    free(A);
    free(B);
    free(C);
    // cudaDeviceSynchronize();

}