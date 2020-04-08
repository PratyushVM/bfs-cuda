#include"../include/graph.h"

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