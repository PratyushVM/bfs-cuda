#include"../include/graph.cuh"

//host function for simple_bfs routine that invokes bfs_kernel iteratively 

void simple_bfs(graph *cpu_g, graph *gpu_g, bool *cpu_done, bool *gpu_done,char **argv)
{
    while(!(*cpu_done))
    {
        *cpu_done = true;
        cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);
        bfs_kernel<<<nblocks,threads_per_block>>>(gpu_g,gpu_done);
        cudaMemcpy(cpu_done,gpu_done,sizeof(bool),cudaMemcpyDeviceToHost);
    }

}