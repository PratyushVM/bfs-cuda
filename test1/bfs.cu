#include<stdio>
#include<cuda>
#include<utility>

#define pii std::pair<int,int>
#define mp std::make_pair
#define f first
#define s second

class graph
{
public:
    
    int v,e; //number of vertices and edges
    int *depth; //array that stores depth (or) distance of each vertex from source
    pii *edgelist; //list of edges in the form of (vertex1,vertex2) pairs  

    graph(int a,int b)
    {
        this->v = a;
        e = b;
        depth = (int*)malloc(v*sizeof(int));
        edgelist =  (pii*)malloc(e*sizeof(pii));
    }
};

__global__ void initialize(graph *g, int start)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x;

    if(id == start)
    g->depth[id] = 0;

    else
    g->depth[id] = -1;
}


int main()
{
    //sample graph
    graph g(5,4);
    graph *cg,*gg;
    cg = &g;
    int start = 2;
    for(int i=0; i<4; i++)
    {
        g.edgelist[i] = mp(i,i+1);
    }

    cudaMalloc((void**)&gg,sizeof(graph));
    cudaMalloc((void**)&gg->edgelist,sizeof(cg->edgelist));
    cudaMalloc((void**)&gg->depth,sizeof(cg->depth));

    cudaMemcpy(gg,cg,sizeof(graph),cudaMemcpyHostToDevice);
    cudaMemcpy(gg->edgelist,cg->edgelist,sizeof(cg->edgelist),cudaMemcpyHostToDevice);
    cudaMemcpy(gg->depth,cg->depth,sizeof(cg->depth),cudaMemcpyHostToDevice);

    initialize<<<1,g.v>>>(gg,start);

    cudaMemcpy(cg,gg,sizeof(graph),cudaMemcpyDeviceToHost);
    cudaMemcpy(cg->edgelist,gg->edgelist,sizeof(gg->edgelist),cudaMemcpyDeviceToHost);
    cudaMemcpy(gg->depth,gg->depth,sizeof(gg->depth),cudaMemcpyDeviceToHost);

    for(int i=0;i<5;i++)
    {
        printf("%d ",cg->depth[i]);
    }


    return 0;
}