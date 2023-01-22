#include<stdio.h>
#include<cuda.h>

#define N 3

__global__ void square_matrix(int *A, int *result) {

	unsigned index = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned i = index / N;
	unsigned j = index % N;
	
	for(unsigned kk = 0; kk < N; kk++) 
		result[index] += A[i*N + kk]*A[kk*N + j];
	
}

int main() {
	int Arr[N*N], result[N*N];
	int *dArr, *dresult;
	
	for(int ii = 0; ii < N*N; ii++)
		Arr[ii] = ii;
		
	cudaMalloc(&dArr, N*N*sizeof(int));
	cudaMemcpy(dArr, Arr, N*N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMalloc(&dresult, N*N*sizeof(int));
	
	square_matrix<<<1, 9>>>(dArr, dresult);
	cudaDeviceSynchronize();
	
	cudaMemcpy(result, dresult, N*N*sizeof(int), cudaMemcpyDeviceToHost);
	
	for(int jj = 0; jj < N*N; jj++) printf("%d ", result[jj]);
	
	return 0;
	
}
	
