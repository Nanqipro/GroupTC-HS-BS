#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>
#include <cstdlib>

using namespace std;

typedef long long index_t;

typedef struct edge
{
    int u, v;
} edge;
typedef struct edge_list
{
    int vertexID;
    vector<int> edge;
} edge_list;

vector<edge_list> vertex;
vector<edge> edgelist;

int maxvertex = 0;
int vertex_count, edge_count;

void randomgraph()
{
    vertex.resize(vertex_count);
    srand(1);
    int e = 0;
    int p = vertex_count * (vertex_count - 1) / 2;
    for (int i = 0; i < vertex_count; i++)
    {
        for (int j = i + 1; j < vertex_count; j++)
        {
            if (rand() % p < edge_count)
            {
                vertex[i].edge.push_back(j);
                e++;
            }
        }
    }
    edge_count = e;
}

void writeback(string prefix)
{
    ofstream beginFile((prefix + "begin.bin").c_str(), ios::out | ios::binary);
    ofstream sourceFile((prefix + "source.bin").c_str(), ios::out | ios::binary);
    ofstream adjFile((prefix + "adjacent.bin").c_str(), ios::out | ios::binary);

    ofstream txtFile((prefix + "dp.txt").c_str(), ios::out);

    long long sum = 0;
    for (int i = 0; i < vertex_count; i++)
    {
        beginFile.write((char *)&sum, sizeof(long long));
        sum += vertex[i].edge.size();
        adjFile.write((char *)&vertex[i].edge[0], sizeof(int) * vertex[i].edge.size());

        for (int j = 0; j < vertex[i].edge.size(); j++)
        {
            sourceFile.write((char *)&i, sizeof(int));
            txtFile << i << ' ' << vertex[i].edge[j] << endl;
        }
    }
    beginFile.write((char *)&sum, sizeof(long long));
}

int main(int argc, char *argv[])
{
    string prefix = argv[1];
    vertex_count = atoi(argv[2]);
    edge_count = atoi(argv[3]);
    // 将边加载到图中
    cout << prefix << endl;
    randomgraph();
    cout << "randomok" << endl;
    cout << vertex_count << "    " << edge_count << endl;

    writeback(prefix);
    cout << "writebackok" << endl;
}