#pragma once
#include <fstream>
#include <string>
#include <iostream>
#include <sstream>
#include <queue>
#include "comm.h"
#include "cuda_comm.h"
#include "graph.h"

class GPUGraph
{
public:
    vertex_t vertex_count;
    vertex_t edge_count;
    vertex_t max_degree;

    index_t *beg_pos;
    vertex_t *src_list;
    vertex_t *adj_list;
    bool has_edge_list;
    vertex_t *edge_list;

public:
    GPUGraph(){};
    GPUGraph(Graph *h_graph);
    ~GPUGraph();
};


