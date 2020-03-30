#include<stdio.h>
#include<utility>
#include<cuda.h>
#include<time.h>

class graph
{
public:
    int num_vertices, num_edges;
    int *depth;
    std::pair<int,int> *edgelist;

    graph()
    {
        depth = (int*)malloc(10*sizeof(int));
        // edgelist = (std::pair<int,int> *)malloc(10*sizeof(std::pair<int,int>));
    }

};

void readgraph(graph &g, int argc, char **argv)
{
    int v,e;

    bool fromstdin = (argc > 2);

    if(!fromstdin)
    {
        scanf("%d %d",&v,&e);
    }

    else
    {
        srand(0);
        v = atoi(argv[2]);
        e = atoi(argv[3]);
    }

    g.num_vertices = v;
    g.num_edges = e;

    if(fromstdin)
    {
        int a,b;
        for(int i=0;i<e;i++)
        {
            scanf("%d %d",&a,&b);
            g.edgelist[i] = std::make_pair(a,b);
        }
    }

    else
    {
        int a,b;
        for(int i=0;i<e;i++)
        {
            a = rand() % v;
            b = rand() % v;
            g.edgelist[i] = std::make_pair(a,b);
        }
    }

}

__global__ void initialize(graph g, int start)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x;

    if(id == start)
    {
        g.depth[id] = 0;
    }

    else
    {
        g.depth[id] = -1;
    }

}


__global__ void bfs(graph &g, int start, int current_depth, bool *stop)
{
    unsigned int e = blockIdx.x*blockDim.x + threadIdx.x;

    int v1 = g.edgelist[e].first;
    int v2 = g.edgelist[e].second;

    int d1 = g.depth[v1];
    int d2 = g.depth[v2];

    if(d1 == current_depth && d2 == -1)
    {
        g.depth[v2] = d1 + 1;
        *stop = false;
    }

    else if(d2 == current_depth && d1 == -1)
    {
        g.depth[v1] = d2 + 1;
        *stop = false;
    }

}

int main()
{
    graph g;
    /*int *start = (int*)argv[1];
    int l = 0;

    readgraph(g,argc,argv);
    initialize<<<1,g.num_vertices>>>(g,*start);

    printf("Number of vertices : %d\n",g.num_vertices);
*///    printf("Number of edges : %d\n",g.num_edges);

    cudaError_t err = cudaSuccess;
    g.num_vertices=5;
    g.num_edges=4;
    for(int i=0;i<5;i++)
    {
        int a = rand() % 5;
        int b = rand() % 5;
        g.edgelist[i] = std::make_pair(a,b);
    }
    int start =2;
    int l=0;
    
    graph *gg = NULL;
    printf("BFS of graph :\n");
    int* a =NULL;
    err = cudaMalloc((void**)&a, sizeof(int));
    if (err != cudaSuccess)
    {
        printf("failed to allocate mem error: %s",cudaGetErrorString(err)); }
    printf("malloc last\n"); //     
    bool *stop;
    
    cudaMalloc((void**)&stop,sizeof(bool));
    err = cudaMalloc((void**)&gg,sizeof(g));
    if (err != cudaSuccess)
    {
        printf("failed to allocate mem error: %s",cudaGetErrorString(err)); }
    cudaMemcpy(gg,&g,sizeof(g),cudaMemcpyHostToDevice);
    
    bool done = false;
    while(!done)
    {
        done = true;
        bfs<<<1,(*gg).num_edges>>>(*gg,start,l,&done);
        cudaMemcpy(&done,stop,sizeof(done),cudaMemcpyDeviceToHost);
        l++;
    }

    printf("Vertex - Level\n");

    for(int i=0; i<(*gg).num_vertices; i++)
    {
        printf("   %d       %d\n",i,(*gg).depth[i]);
    }

    return 0;
}




 