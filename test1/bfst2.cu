#include<stdio.h>
#include<cuda.h>
#include<utility>

#define pii std::pair<int,int>
#define mp std::make_pair
#define f first
#define s second

//declaration of class object
class graph
{
public:
    
    int v,e; //number of vertices and edges
    int *depth; //array that stores depth (or) distance of each vertex from source
    pii *edgelist; //list of edges in the form of (vertex1,vertex2) pairs  

};

//Kernel that initializes depth array of graph

__global__ void init(graph *g, int start)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread

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

//Kernel invoked in bfs routine

__global__ void bfs(graph *g, bool *done)
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

}

//main function

int main()
{
    //declaration of variables to store graph data on host and device
    graph *cpu_g,*gpu_g;
    int *c_depth,*g_depth;
    pii *c_edgelist,*g_edgelist;
    int nv = 5;
    int ne = 4;
    int start = 2;

    //allocating host memory for data of graph in host
    c_depth = (int*)malloc(nv*sizeof(int));
    c_edgelist = (pii *)malloc(ne*sizeof(pii));

    //allocating host memory for graph object
    cpu_g = (graph*)malloc(sizeof(graph));

    //assigning values to data members of graph object from host data
    cpu_g->v = nv;
    cpu_g->e = ne;
    cpu_g->depth = c_depth;
    cpu_g->edgelist = c_edgelist;
    
    for(int i=0; i<ne; i++)
    {
        c_edgelist[i] = mp(i,i+1);
    }

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
    init<<<1,nv>>>(gpu_g,start);

    //declaration of bool variables in host for routine to invoke bfs kernel
    bool *cpu_done;
    cpu_done = (bool*)malloc(sizeof(bool));
    *cpu_done = false;

    //declaration of bool variables in device for routine to invoke bfs kernel   
    bool *gpu_done;
    cudaMalloc((void**)&gpu_done,sizeof(bool));
    cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);

    // routine that invokes bfs kernel from host

    while(!(*cpu_done))
    {
        *cpu_done = true;
        cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);
        bfs<<<1,ne>>>(gpu_g,gpu_done);
        cudaMemcpy(cpu_done,gpu_done,sizeof(bool),cudaMemcpyDeviceToHost);
    }

    //copying device data back into host memory
    cudaMemcpy(c_depth,g_depth,nv*sizeof(int),cudaMemcpyDeviceToHost);
    cudaMemcpy(c_edgelist,g_edgelist,ne*sizeof(pii),cudaMemcpyDeviceToHost);
    cudaMemcpy(cpu_g,gpu_g,sizeof(graph),cudaMemcpyDeviceToHost);

    cpu_g->edgelist = c_edgelist;
    cpu_g->depth = c_depth;

    //printing depth of vertices from host memory
    for(int i=0;i<nv;i++)
    {
        printf("The depth of vertex %d is %d\n",i,cpu_g->depth[i]);
    }

}