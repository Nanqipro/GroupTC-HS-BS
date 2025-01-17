#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>

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
void loadgraph(string prefix, string filename)
{
    ifstream inFile((prefix + filename).c_str(), ios::in);
    if (!inFile)
    {
        cout << "error" << endl;
    }
    int x;
    string line;
    stringstream ss;
    getline(inFile, line);
    ss.str("");
    ss.clear();
    ss << line;
    ss >> vertex_count >> x >> edge_count;
    vertex.resize(vertex_count);
    while (getline(inFile, line))
    {
        if (line[0] < '0' || line[0] > '9')
            continue;
        ss.str("");
        ss.clear();
        ss << line;
        int u, v;
        ss >> u >> v;
        vertex[u].edge.push_back(v);
    }
}

void writeback(string prefix)
{
    ofstream beginFile((prefix + "begin.bin").c_str(), ios::out | ios::binary);
    ofstream sourceFile((prefix + "source.bin").c_str(), ios::out | ios::binary);
    ofstream adjFile((prefix + "adjacent.bin").c_str(), ios::out | ios::binary);
    long long sum = 0;
    for (int i = 0; i < vertex_count; i++)
    {
        beginFile.write((char *)&sum, sizeof(long long));
        sum += vertex[i].edge.size();
        adjFile.write((char *)&vertex[i].edge[0], sizeof(int) * vertex[i].edge.size());

        for (int j = 0; j < vertex[i].edge.size(); j++)
        {
            sourceFile.write((char *)&i, sizeof(int));
        }
    }

    beginFile.write((char *)&sum, sizeof(long long));
}

int main(int argc, char *argv[])
{
    string prefix = argv[1];
    string Infilename = argv[2];
    //将边加载到图中
    loadgraph(prefix, Infilename);
    cout << "loadok" << endl;

    writeback(prefix);
    cout << "writebackok" << endl;
}