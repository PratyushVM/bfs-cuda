#include"../include/graph.cuh"

//Kernel that initializes depth array of graph

__global__ void init_depth_kernel(graph *g, int start)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread
    if(id<g->v)
    {
        //checking if vertex is the starting point of bfs or not, and initializing depth value respectively
        if(id == start)
        {
            g->depth[id] = 0;
        }

        else
        {
            g->depth[id] = -1;
        }

    }
}