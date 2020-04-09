#ifndef __GRAPH__HEADER__CUDA__
#define __GRAPH__HEADER__CUDA__

#include<cuda.h>
#include"graph.h"

//function prototypes for kernels 

__global__ void init_depth_kernel(graph *g, int start);
__global__ void bfs_kernel(graph *g, bool *done);

#endif

