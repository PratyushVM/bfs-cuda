#ifndef __GRAPH__HEADER__
#define __GRAPH__HEADER__

#include<stdio.h>
#include<utility>
#include<list>
#include<vector>
#include<bits/stdc++.h>

#define pii std::pair<int,int>
#define list std::list
#define mp std::make_pair
#define pb push_back
#define vector std::vector

#define nthreads atoi(argv[2])
#define threads_per_block 256
#define nblocks nthreads/threads_per_block + 1

//declaration of class object - graph

class graph
{
public:
    
    int v,e; //number of vertices and edges
    int *depth; //array that stores depth (or) distance of each vertex from source
    pii *edgelist; //list of edges in the form of (vertex1,vertex2) pairs  

};

//function prototypes for host functions

void simple_bfs(graph *cpu_g, graph *gpu_g, bool *cpu_done, bool *gpu_done, char **argv);
void readgraph(pii *c_edgelist, int nv, int ne, int argc, char **argv);
void printgraph(graph *cpu_g);
void check(graph *cpu_g, pii *c_edgelist,int start);


#endif

