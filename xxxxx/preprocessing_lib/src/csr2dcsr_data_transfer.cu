#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>
#include <string>
#include "csr2dcsr_data_transfer.h"
#include "cuda_graph_comm.h"
#include "spdlog/spdlog.h"
#include "constant_comm.h"

void Csr2DcsrDataTransfer::transfer()
{

    vertex_t *d_degree_arr;
    vertex_t *d_edge_arr;

    vertex_t vertex_count = d_graph.vertex_count;
    vertex_t edge_count = d_graph.edge_count;
    vertex_t *d_src_arr = d_graph.src_list;
    vertex_t *d_adj_arr = d_graph.adj_list;
    index_t *d_offset_arr = d_graph.beg_pos;

    vertex_t *h_src_arr = h_graph.src_list;
    vertex_t *h_adj_arr = h_graph.adj_list;
    index_t *h_offset_arr = h_graph.beg_pos;

    size_t size_degree_arr = sizeof(vertex_t) * vertex_count;
    size_t size_offset_arr = sizeof(index_t) * (vertex_count + 1);
    size_t size_src_arr = sizeof(vertex_t) * edge_count;
    size_t size_edge_arr = size_src_arr * 2;

    for (int i = 0; i < 10; i++)
    {
        spdlog::debug("arr[{0}]: {1}", i, h_offset_arr[i]);
    }

    HRR(cudaMalloc((void **)&d_degree_arr, size_degree_arr));
    HRR(cudaMalloc((void **)&d_edge_arr, size_edge_arr));

    HRR(cudaMemset(d_degree_arr, 0, size_degree_arr));

    int block_size = 1024;
    int grid_size = (edge_count - 1) / block_size + 1;

    int max_degree = compute_max_degree();

    spdlog::info("CSR2DCSR graph transfer start, graph max degree is {}", max_degree);

    double t_start = wtime();

    int iterations = constant_comm::kTransferIterations;
    for (int k = 0; k < iterations; k++)
    {
        cuda_graph_comm::cal_degree_and_zip_edge<<<grid_size, block_size>>>(edge_count, vertex_count, d_degree_arr, d_edge_arr, d_src_arr, d_adj_arr);
        HRR(cudaDeviceSynchronize());

        cuda_graph_comm::redirect_edge<<<grid_size, block_size>>>(edge_count, vertex_count, d_degree_arr, d_edge_arr);
        HRR(cudaDeviceSynchronize());

        thrust::device_ptr<uint64_t> sort_ptr((uint64_t *)d_edge_arr);
        thrust::sort(sort_ptr, sort_ptr + edge_count);

        cuda_graph_comm::unzip_edge<<<grid_size, block_size>>>(edge_count, vertex_count, d_edge_arr, d_src_arr, d_adj_arr);
        HRR(cudaDeviceSynchronize());

        cuda_graph_comm::recal_offset<<<grid_size, block_size>>>(edge_count, vertex_count, d_src_arr, d_offset_arr);
        HRR(cudaDeviceSynchronize());
    }
    double t_end = wtime();

    spdlog::info("iterate {0} times, avg time consumption {1:.6f} s", iterations, (t_end - t_start) / iterations);

    cuda_graph_comm::check_array("d_src_arr", d_src_arr, edge_count, 0, 10);
    cuda_graph_comm::check_array("d_adj_arr", d_adj_arr, edge_count, 0, 10);
    cuda_graph_comm::check_array("d_offset_arr", d_offset_arr, vertex_count + 1, 0, 10);

    HRR(cudaMemcpy(h_offset_arr, d_offset_arr, size_offset_arr, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(h_src_arr, d_src_arr, size_src_arr, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(h_adj_arr, d_adj_arr, size_src_arr, cudaMemcpyDeviceToHost));

    max_degree = compute_max_degree();
    spdlog::info("CSR2DCSR graph transfer finished, graph max degree is {}", max_degree);

    cudaFree(d_degree_arr);
    cudaFree(d_edge_arr);
}
