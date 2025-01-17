#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>
#include <string>
#include "data_transfer.h"
#include "cuda_graph_comm.h"
#include "constant_comm.h"
#include "spdlog/spdlog.h"

bool DataTransfer::degree_less(vertex &a, vertex &b)
{
    return a.degree < b.degree;
}

bool DataTransfer::degree_greather(vertex &a, vertex &b)
{
    return a.degree > b.degree;
}

bool DataTransfer::edge_less(edge &a, edge &b)
{
    return a.u < b.u || (a.u == b.u && a.v < b.v);
}

bool DataTransfer::edge_greather(edge &a, edge &b)
{
    return a.u > b.u || (a.u == b.u && a.v > b.v);
}

DataTransfer::DataTransfer(std::string file) : input_file(file), h_graph(input_file), d_graph(&h_graph) {}


int DataTransfer::compute_max_degree()
{
    index_t *offset_arr = h_graph.beg_pos;
    vertex_t vertex_count = h_graph.vertex_count;

    int max_degre = 0;
    for (index_t i = 1; i <= vertex_count; i++)
    {
        if (offset_arr[i] - offset_arr[i - 1] > max_degre)
        {
            max_degre = offset_arr[i] - offset_arr[i - 1];
        }
    }
    return max_degre;
}
