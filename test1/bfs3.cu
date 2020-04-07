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

__global__ void init_depth_kernel(graph *g, int start)
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

}

//host function that invokes bfs_kernel iteratively 

void simple_bfs(graph *cpu_g, graph *gpu_g, bool *cpu_done, bool *gpu_done)
{
    while(!(*cpu_done))
    {
        *cpu_done = true;
        cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);
        bfs_kernel<<<1,cpu_g->e>>>(gpu_g,gpu_done);
        cudaMemcpy(cpu_done,gpu_done,sizeof(bool),cudaMemcpyDeviceToHost);
    }

}

//host function that reads graph data from command line

void readgraph(pii *c_edgelist, int nv, int ne, int argc, char **argv)
{
    if(argc <= 4 || argc%2 != 0)
    {
        printf("Enter valid arguments in command line\n");
        exit(0);
    }

    else
    {
        int i,j;
        for(i=0, j=4;j<argc-1;i++,j+=2)
        {
            c_edgelist[i] = mp(atoi(argv[j]),atoi(argv[j+1]));
        }
    }
    
}

//host function to print the depth of each vertex

void printgraph(graph *cpu_g)
{
    for(int i=0;i<cpu_g->v;i++)
    {
        printf("The depth of vertex %d is %d\n",i,cpu_g->depth[i]);
    }
}

//main function

int main(int argc, char **argv)
{
    //declaration of variables to store graph data on host and device
    graph *cpu_g,*gpu_g;
    int *c_depth,*g_depth;
    pii *c_edgelist,*g_edgelist;

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

    //declaration of bool variables in host for routine to invoke bfs kernel
    bool *cpu_done;
    cpu_done = (bool*)malloc(sizeof(bool));
    *cpu_done = false;

    //declaration of bool variables in device for routine to invoke bfs kernel   
    bool *gpu_done;
    cudaMalloc((void**)&gpu_done,sizeof(bool));
    cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);

    // routine that invokes bfs kernel from host
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