#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cuda.h>

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

    /// to get a semi optimal block size we can do 
    /// size/32 =64



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


    cudaEvent_t start,stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    // Lunching the kernel
    cudaEventRecord(start);
    vectorAdd<<<64,32>>>(dA,dB,dC,SIZE);
    cudaEventRecord(stop);
    // cudaDeviceSynchronize();



    //copy result back to host.
    cudaMemcpy(C,dC,size,cudaMemcpyDeviceToHost);
    printf("\nExecution finished\n");

    cudaEventSynchronize(stop);
    float milliseconds=0;
    cudaEventElapsedTime(&milliseconds,start,stop);
    printf("Execution time: %f milliseconds\n",milliseconds);




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