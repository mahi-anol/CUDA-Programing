#include <stdio.h>

int main(){

    int nDevices;

    cudaGetDeviceCount(&nDevices);

    for(int i=0;i<nDevices;i++){
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop,i);
        printf("Device Number: %d\n",i);
        printf("Device Name: %s\n",prop.name);

        int memoryClockRate = 0;
        cudaDeviceGetAttribute(&memoryClockRate, cudaDevAttrMemoryClockRate, i);
        printf("Memory Clock Rate (mHz): %f\n",memoryClockRate*1e-3);

        printf("Memory Bus width (bits): %d\n",prop.memoryBusWidth);
        printf("Peck Memory Bandwidth (GB/s): %f\n",2.0*memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);

        printf("Total global memory (GB): %f\n",prop.totalGlobalMem/(1024*1024*1024.0));
        printf("Compute capability: %d.%d\n",prop.major,prop.minor);
        printf("Number of SMs: %d\n",prop.multiProcessorCount);
        printf("Max threads per block: %d\n",prop.maxThreadsPerBlock);
        // //Max thread per block
        printf("Max threads dimentions: x = %d, y = %d, z = %d\n",prop.maxThreadsDim[0],prop.maxThreadsDim[1],prop.maxThreadsDim[2]);
        // //block per grid.
        printf("Max grid dimentions: x = %d,y = %d,z = %d\n",prop.maxGridSize[0],prop.maxGridSize[1],prop.maxGridSize[2]);
    }

    return 0;
}