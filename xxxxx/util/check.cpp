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
int vertex_count = 100000, edge_count = 102350000;
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
    int preU = 0;
    int preV = 0;
    int degree = 0;
    while (getline(inFile, line))
    {
        if (line[0] < '0' || line[0] > '9')
            continue;
        ss.str("");
        ss.clear();
        ss << line;
        int u, v;
        ss >> u >> v;
        if (u == preU)
        {
            degree++;
            if (v < preV)
            {
                printf("error: %d, %d\n", u, v);
            }
        }
        else
        {
            if (degree != 2047)
            {
                printf("degree error: %d, %d\n", u, v);
            }
            preU = u;
            degree = 1;
        }
        preV = v;
    }
}

int main(int argc, char *argv[])
{
    string prefix = argv[1];
    string Infilename = argv[2];
    //将边加载到图中
    loadgraph(prefix, Infilename);
    cout << "checkok" << endl;
}