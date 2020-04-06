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

    graph(int v, int e)
    {
        num_vertices = v;
        num_edges = e;
        depth = (int*)malloc(v*sizeof(int));
        edgelist = (std::pair<int,int> *)malloc(e*sizeof(std::pair<int,int>));
    }
};

/*void readgraph(graph &g, int argc, char **argv)
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

}*/

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

    if(d1 != -1 && d2 == -1)
    {
        g.depth[v2] = current_depth + 1;
        *stop = false;
    }

    else if(d2 != -1 && d1 == -1)
    {
        g.depth[v1] = current_depth + 1;
        *stop = false;
    }

}

int main(int argc, char **argv)
{
    /*int v,e;
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

    graph g(v,e);

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
    */
    //int *start = (int*)argv[1];
    int l = 0;
    int *start = (int *)2;
    //readgraph(g,argc,argv);
    
    graph g(5,4);
    for(int i=0;i<4;i++)
    {
        g.edgelist[i] = std::make_pair(i,i+1);
    }

    printf("Number of vertices : %d\n",g.num_vertices);
    printf("Number of edges : %d\n",g.num_edges);

    for(int i=0;i<g.num_vertices;i++)
    {
        g.depth[i] = -1;
    }
    g.depth[2] = 0;
    graph *gg;
    cudaMalloc(&gg,sizeof(g));
    cudaMemcpy(gg,&g,sizeof(g),cudaMemcpyHostToDevice);

    //initialize<<<1,g.num_vertices>>>(*gg,*start);
    


    printf("BFS of graph :\n");
    bool done = false;
    bool *stop;

    cudaMalloc(&stop,sizeof(bool));

    //while(!done)
    {
        done = true;
        bfs<<<1,g.num_edges>>>(*gg,2,l,&done);
        cudaMemcpy(&done,stop,sizeof(done),cudaMemcpyDeviceToHost);
        l++;
    }

    cudaMemcpy(&g,gg,sizeof(g),cudaMemcpyDeviceToHost);

    printf("Vertex - Level\n");

    for(int i=0; i<(g).num_vertices; i++)
    {
        printf("   %d       %d\n",i,(g).depth[i]);
    }

    return 0;
}