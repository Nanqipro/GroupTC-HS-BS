#include <thrust/device_ptr.h>
#include <thrust/functional.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>
#include <cuda_profiler_api.h>
#include "../comm/cuda_comm.h"

#define block_bucketnum 256
#define subwarp_size 256
#define warp_step block_bucketnum / subwarp_size
#define BATCH_SIZE 4

int grid_size = NumberOfMPs() * 8;
int block_size = WarpSize() * 2;

int edge_count;
int vertex_count;
int iterator_count = 100;

__device__ int bin_search1(vertex_t *arr, int len, int val)
{

	uint32_t Y;
	int32_t bot = 0;
	int32_t top = len - 1;
	int32_t r;
	while (top >= bot)
	{
		r = (top + bot) / 2;
		Y = arr[r];

		if (val == Y)
		{
			return 1;
		}
		if (val < Y)
		{
			top = r - 1;
		}
		else
		{
			bot = r + 1;
		}
	}
	return 0;
}

// __device__ int bin_search(vertex_t *arr, int len, int val)
// {
// 	int ret = 0;
// 	int halfsize;
// 	int candidate;
// 	int temp = len;
// 	while (temp > 1)
// 	{
// 		halfsize = temp / 2;
// 		candidate = arr[ret + halfsize];
// 		ret += (candidate < val) ? halfsize : 0;
// 		temp -= halfsize;
// 	}
// 	ret += (arr[ret] < val);
// 	return ret < len && arr[ret] == val;
// }

__device__ int bin_search(vertex_t *arr, int len, int val, int &offset)
{
	int ret = 0;
	int halfsize;
	int candidate;
	int temp = len;
	while (temp > 1)
	{
		halfsize = temp / 2;
		candidate = arr[ret + halfsize];
		ret += (candidate < val) ? halfsize : 0;
		temp -= halfsize;
	}
	ret += (arr[ret] < val);
	offset = ret;
	return ret < len && arr[ret] == val;
}

// template <const int EPB, const int NPT, const int SUBWARP_SIZE>
__global__ void grouptc(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, int edge_count, int vertex_count, unsigned long long *GLOBAL_COUNT)
{

	// 共享内存中的 hashTable
	__shared__ int sh_tb_start[block_bucketnum];
	__shared__ int sh_tb_len[block_bucketnum];
	__shared__ int sh_ele_start[block_bucketnum];
	__shared__ int sh_ele_len[block_bucketnum];

	__shared__ int sh_cache_parent[block_bucketnum * BATCH_SIZE];
	__shared__ int sh_cache_value[block_bucketnum * BATCH_SIZE];

	unsigned long long P_counter = 0;

	int bid = blockIdx.x;
	int tid = threadIdx.x;

	for (int blockEdgeIdx = bid * block_bucketnum; blockEdgeIdx < edge_count; blockEdgeIdx += gridDim.x * block_bucketnum)
	{
		if (blockEdgeIdx + tid < edge_count)
		{
			int src = src_list[blockEdgeIdx + tid];
			int dst = adj_list[blockEdgeIdx + tid];
			int temp;

			int tb_start, tb_len, ele_start, ele_len;
			tb_start = blockEdgeIdx + tid + 1;
			tb_len = beg_pos[src + 1] - tb_start;
			ele_start = beg_pos[dst];
			ele_len = beg_pos[dst + 1] - ele_start;

			if (tb_len * 2 < ele_len)
			{
				temp = tb_start;
				tb_start = ele_start;
				ele_start = temp;

				temp = tb_len;
				tb_len = ele_len;
				ele_len = temp;
			}

			sh_tb_start[tid] = tb_start;
			sh_tb_len[tid] = tb_len;
			sh_ele_start[tid] = ele_start;
			sh_ele_len[tid] = ele_len;
		}

		__syncthreads();

		int warpID = tid / subwarp_size;
		int now = warpID * subwarp_size;
		int end = min(edge_count - blockEdgeIdx, (warpID + 1) * subwarp_size);
		int workid = tid % subwarp_size;
		int offset = 0;
		int last_now = -1;

		// 获取二跳邻居节点
		int neighbor_degree = sh_ele_len[now];
		while (now < end)
		{
			for (int iter = 0; iter < BATCH_SIZE; iter++)
			{
				// 如果当前一阶邻居节点已被处理完，找下一个一阶邻居节点去处理
				while (now < end && workid >= neighbor_degree)
				{
					now++;
					if (now < end)
					{
						workid -= neighbor_degree;
						neighbor_degree = sh_ele_len[now];
					}
				}

				if (now < end)
				{
					offset = last_now == now ? offset : 0;
					int val = adj_list[sh_ele_start[now] + workid];

					sh_cache_parent[iter * block_bucketnum + tid] = now;
					sh_cache_value[iter * block_bucketnum + tid] = val;

					// // load to register
					// // tmp[iter] = val;
					// P_counter += bin_search(adj_list + (sh_tb_start[now] + offset), sh_tb_len[now] - offset, adj_list[sh_ele_start[now] + workid], offset);
					// last_now = now;
				}
			}
			// __syncthreads();

			// compute
			int parent, val;
			for (int iter = 0; iter < BATCH_SIZE; iter++)
			{
				parent = sh_cache_parent[iter + tid * BATCH_SIZE];
				val = sh_cache_value[iter + tid * BATCH_SIZE];
				P_counter += bin_search(adj_list + (sh_tb_start[parent] + offset), sh_tb_len[parent] - offset, val , offset);
				last_now = parent;
			}

			workid += subwarp_size;
		}
		__syncthreads();
	}

	// atomicAdd(GLOBAL_COUNT2, P_counter);
	GLOBAL_COUNT[bid * block_bucketnum + tid] = P_counter;
}

void gpu_run(vertex_t *d_source, vertex_t *d_adj, index_t *d_offset, unsigned long long *results)
{

	double t_start, total_kernel_use = 0;
	uint64_t count;
	cudaProfilerStop();
	for (int i = 0; i < iterator_count; i++)
	{
		cudaMemset(results, grid_size * block_bucketnum * sizeof(unsigned long long), 0);
		t_start = wtime();
		cudaProfilerStart();
		grouptc<<<grid_size, block_bucketnum>>>(d_source, d_adj, d_offset, edge_count, vertex_count, results);
		HRR(cudaDeviceSynchronize());
		cudaProfilerStop();
		thrust::device_ptr<unsigned long long> ptr(results);
		count = thrust::reduce(ptr, ptr + (grid_size * block_bucketnum));
		double ee = wtime();
		total_kernel_use += ee - t_start;
		if (i == 0)
		{
			if (ee - t_start > 0.1 && iterator_count != 1)
			{
				iterator_count = 10;
			}
		}
	}

	printf("iter %d, avg kernel use %lf s\n", iterator_count, total_kernel_use / iterator_count);
	printf("triangle count %ld \n\n", count);
}

void TC_gpu(graph *graph_d)
{

	long int edge_size = sizeof(vertex_t) * edge_count;
	long int offset_size = sizeof(index_t) * (vertex_count + 1);

	vertex_t *d_source, *d_adj;
	index_t *d_offset;
	unsigned long long *results;
	HRR(cudaMalloc(&d_source, edge_size));
	HRR(cudaMalloc(&d_adj, edge_size));
	HRR(cudaMalloc(&d_offset, offset_size));
	// HRR(cudaMalloc(&results, grid_size * block_bucketnum * sizeof(unsigned long long)));

	// HRR(cudaMalloc(&results, edge_count * sizeof(unsigned long long)));
	HRR(cudaMalloc(&results, grid_size * block_bucketnum * sizeof(unsigned long long)));

	HRR(cudaMemcpy(d_source, graph_d->source_list, edge_size, cudaMemcpyHostToDevice));
	HRR(cudaMemcpy(d_adj, graph_d->adj_list, edge_size, cudaMemcpyHostToDevice));
	HRR(cudaMemcpy(d_offset, graph_d->beg_pos, offset_size, cudaMemcpyHostToDevice));

	gpu_run(d_source, d_adj, d_offset, results);

	HRR(cudaFree(d_source));
	HRR(cudaFree(d_adj));
	HRR(cudaFree(d_offset));
	HRR(cudaFree(results));
}

int main(int argc, char **argv)
{
	string file = argv[1];
	if (argc >= 4)
	{
		iterator_count = atoi(argv[3]);
	}
	if (argc >= 5)
	{
		grid_size = atoi(argv[4]);
		block_size = atoi(argv[5]);
	}

	cudaSetDevice(atoi(argv[2]));

	graph *graph_d = readGraph(file);
	edge_count = graph_d->edge_count;
	vertex_count = graph_d->vertex_count;

	cout << "dataset\t" << file << endl;
	cout << "Number of nodes: " << vertex_count
		 << ", number of edges: " << edge_count << endl;

	TC_gpu(graph_d);

	return 0;
}
