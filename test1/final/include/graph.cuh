#ifndef __GRAPH__HEADER__CUDA__
#define __GRAPH__HEADER__CUDA

//#include<stdio.h>
#include<cuda.h>
//#include<utility>
#include"graph.h"

/*#define pii std::pair<int,int>
#define mp std::make_pair
#define f first
#define s second

//declaration of class object - graph

class graph
{
public:
    
    int v,e; //number of vertices and edges
    int *depth; //array that stores depth (or) distance of each vertex from source
    pii *edgelist; //list of edges in the form of (vertex1,vertex2) pairs  

};

//function prototypes for host functions

void simple_bfs(graph *cpu_g, graph *gpu_g, bool *cpu_done, bool *gpu_done);
void readgraph(pii *c_edgelist, int nv, int ne, int argc, char **argv);
void printgraph(graph *cpu_g);*/

//function prototypes for kernels 

__global__ void init_depth_kernel(graph *g, int start);
__global__ void bfs_kernel(graph *g, bool *done);

#endif

