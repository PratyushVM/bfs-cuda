#include"../include/graph.cuh"


//Kernel invoked in simple_bfs routine

__global__ void bfs_kernel(graph *g, bool *done)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread

    //storing corresponding vertices and depth values into thread's local memory 
    int v1 = g->edgelist[id].f;
    int v2 = g->edgelist[id].s;
    int d1 = g->depth[v1];
    int d2 = g->depth[v2];

    //checking if vertex of next depth value is discovered
    if(d1 != -1 && d2 == -1)
    {
        g->depth[v2] = g->depth[v1] + 1;
        *done = false;
    }
    
    else if(d2 != -1 && d1 == -1)
    {
        g->depth[v1] = g->depth[v2] + 1;
        *done = false;
    }

    //*done is used to determine if the bfs_kernel shoulb be invoked again by simple_bfs routine

}