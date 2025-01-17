#pragma once
#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>
#include <string>
#include "graph.h"
#include "gpu_graph.h"

class DataTransfer
{

public:
    std::string input_file;
    Graph h_graph;
    GPUGraph d_graph;

public:
    static bool degree_less(vertex &a, vertex &b);

    static bool degree_greather(vertex &a, vertex &b);

    static bool edge_less(edge &a, edge &b);

    static bool edge_greather(edge &a, edge &b);

    static void graph_comparasion(Graph graph_1, Graph graph_2){};

    static void gpu_graph_comparasion(GPUGraph gpu_graph_1, GPUGraph gpu_graph_2){};

    DataTransfer(std::string file);

    ~DataTransfer(){};

    virtual void transfer(){};

    int compute_max_degree();
};