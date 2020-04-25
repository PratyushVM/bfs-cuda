#include"../include/graph.cuh"


//Kernel invoked in simple_bfs routine

__global__ void bfs_kernel(graph *g, bool *done, int current_depth)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread
    if(id < g->e)
    {

        //storing corresponding vertices and depth values into thread's local memory 
        int v1 = g->edgelist[id].first;
        int v2 = g->edgelist[id].second;
        int d1 = g->depth[v1];
        int d2 = g->depth[v2];
        

        //checking if vertex of next depth value is discovered
        if(d1 == current_depth && d2 == -1)
        {
            g->depth[v2] = d1 + 1;
            *done = false;
        }
        
        else if(d2 == current_depth && d1 == -1)
        {
            g->depth[v1] = d2 + 1;
            *done = false;
        }

        //*done is used to determine if the bfs_kernel shoulb be invoked again by simple_bfs routine

    }

}