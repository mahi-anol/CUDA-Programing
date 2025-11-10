#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cuda.h>


/// Main problem for large context is the available memory(ram or gpu memeory)
#define TOTAL_SIZE 1024*1024*1024 // defining vector size  so, A=4GB B=4GB=8GB, C=4GB....Total 12GB.!!!!!
/// So do add such large vector beyond capacity....I use sliding window....
#define CHUNK_SIZE 1024*1024*128
#define BLOCK_SIZE 1024

// CUDA kernel vector addition.
__global__ void vectorAdd(int* A,int* B,int* C,int chunkSize){
    int i=threadIdx.x+blockIdx.x*blockDim.x; //blockDim= number of thread per block.
    if(i<chunkSize){ // avoiding out of bound error.
        C[i]=A[i]+B[i];
    }
}


//helper function
void random_ints(int* x,int size){
    /*
        Desc: This function initializes an array with random numbers.
        Args: x=pointer to the array, size= size of the array.
        Returns: None
    */
    for(int i=0;i<size;i++){
        x[i]=rand()%100; // any number between 1 and 100
    }
}

//helper function
void show_result(int* a,int *b,int *c,int chunk_size){

    for (int i=0;i<chunk_size;i++)
    {
        printf("%d + %d = %d\n",a[i],b[i],c[i]);
    }

}
int main()
{   ///Adding two vector of size 1024

    // Index size for vector.
    size_t chunkSizeBytes=CHUNK_SIZE*sizeof(int);

    /// to get a semi optimal block size we can do 
    /// size/32 =64

    // Allocating cpu memory
    int* chunkA ,* chunkB,* chunkC;
    chunkA=(int*)malloc(chunkSizeBytes);
    chunkB=(int*)malloc(chunkSizeBytes);
    chunkC=(int*)malloc(chunkSizeBytes);

    // Allocating Device memeory
    int* dA,* dB,* dC;
    cudaMalloc((void**)&dA,chunkSizeBytes);
    cudaMalloc((void**)&dB,chunkSizeBytes);
    cudaMalloc((void**)&dC,chunkSizeBytes);

    int numBlocks=(CHUNK_SIZE+BLOCK_SIZE-1)/BLOCK_SIZE;
    // assigning input
    for(long long offset=0, offset_id=0;offset<TOTAL_SIZE;offset+=CHUNK_SIZE,offset_id++){
        int currentChunkSize=(TOTAL_SIZE-offset)<CHUNK_SIZE?(TOTAL_SIZE-offset):CHUNK_SIZE;
        printf("Offset id: %lld",offset_id);
        printf("Indexes covered till now: %lld",offset);

        random_ints(chunkA,CHUNK_SIZE);
        random_ints(chunkB,CHUNK_SIZE);
        cudaMemcpy(dA,chunkA,currentChunkSize*sizeof(int),cudaMemcpyHostToDevice);
        cudaMemcpy(dB,chunkB,currentChunkSize*sizeof(int),cudaMemcpyHostToDevice);
        


        cudaEvent_t start,stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);
        vectorAdd<<<numBlocks,BLOCK_SIZE>>>(dA,dB,dC,currentChunkSize);
        cudaEventRecord(stop);
        cudaMemcpy(chunkC,dC,currentChunkSize*sizeof(int),cudaMemcpyDeviceToHost);
        cudaEventSynchronize(stop);
        float milliseconds=0;
        cudaEventElapsedTime(&milliseconds,start,stop);
        printf("Execution time: %f milliseconds\n",milliseconds);
        show_result(chunkA,chunkB,chunkC,currentChunkSize);
        break;
    }
    // Cleaning memory
    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);
    free(chunkA);
    free(chunkB);
    free(chunkC);
    // cudaDeviceSynchronize();

}