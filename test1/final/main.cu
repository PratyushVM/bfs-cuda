#include"include/graph.h"
#include"include/graph.cuh"
//main function

int main(int argc, char **argv)
{
    //declaration of variables to store graph data on host and device
    graph *cpu_g,*gpu_g;
    int *c_depth,*g_depth;
    pii *c_edgelist,*g_edgelist;

    //asking user to run with inputs in command line if no inputs are given
    if(argc == 1)
    {
        printf("Enter arguments in command line\n");
        return 0;
    }

    int nv = atoi(argv[1]); //number of vertices
    int ne = atoi(argv[2]); //number of edges
    int start = atoi(argv[3]);  //starting vertex for bfs

    //allocating host memory for data of graph in host
    c_depth = (int*)malloc(nv*sizeof(int));
    c_edgelist = (pii *)malloc(ne*sizeof(pii));

    //invoking function to read graph data from command line
    readgraph(c_edgelist,nv,ne,argc,argv);

    //allocating host memory for graph object
    cpu_g = (graph*)malloc(sizeof(graph));

    //assigning values to data members of graph object from host data
    cpu_g->v = nv;
    cpu_g->e = ne;
    cpu_g->depth = c_depth;
    cpu_g->edgelist = c_edgelist;

    //allocating device memory for graph object on GPU    
    cudaMalloc((void**)&gpu_g,sizeof(graph));
    cudaMalloc((void**)&g_depth,nv*sizeof(int));
    cudaMalloc((void**)&g_edgelist,ne*sizeof(pii));

    //copying host data onto device
    cudaMemcpy(g_depth,c_depth,nv*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(g_edgelist,c_edgelist,ne*sizeof(pii),cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_g,cpu_g,sizeof(graph),cudaMemcpyHostToDevice);

    cudaMemcpy(&(gpu_g->edgelist),&g_edgelist,sizeof(pii *),cudaMemcpyHostToDevice);
    cudaMemcpy(&(gpu_g->depth),&g_depth,sizeof(int*),cudaMemcpyHostToDevice);

    //invoking kernel to initialize the depth array of the graph 
    init_depth_kernel<<<1,nv>>>(gpu_g,start);

    //declaration of bool variables in host - used for routine to invoke bfs kernel
    bool *cpu_done;
    cpu_done = (bool*)malloc(sizeof(bool));
    *cpu_done = false;

    //declaration of bool variables in device for routine to invoke bfs kernel   
    bool *gpu_done;
    cudaMalloc((void**)&gpu_done,sizeof(bool));
    cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);

    //routine that invokes bfs kernel from host
    simple_bfs(cpu_g,gpu_g,cpu_done,gpu_done);

    //copying device data back into host memory
    cudaMemcpy(c_depth,g_depth,nv*sizeof(int),cudaMemcpyDeviceToHost);
    cudaMemcpy(c_edgelist,g_edgelist,ne*sizeof(pii),cudaMemcpyDeviceToHost);
    cudaMemcpy(cpu_g,gpu_g,sizeof(graph),cudaMemcpyDeviceToHost);
    
    cpu_g->edgelist = c_edgelist;
    cpu_g->depth = c_depth;

    //printing depth of vertices from host memory
    printgraph(cpu_g);
   
    return 0;

}