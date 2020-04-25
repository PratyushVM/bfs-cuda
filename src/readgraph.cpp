#include"../include/graph.h"
#include<cstdlib>
#include<bits/stdc++.h>
#include<fstream>
#include<sstream>


//host function that reads graph data from command line

void readgraph(pii *c_edgelist, int nv, int ne, int argc, char **argv)
{
     
   FILE *fp = fopen("edgelist.txt","r");

   char buf1[10],buf2[10];

   int i=0,e1,e2;

   while(i<ne)
   {
       fscanf(fp,"%s",buf1);
       fscanf(fp,"%s",buf2);
       e1 = atoi(buf1);
       e2 = atoi(buf2);
       c_edgelist[i++] = mp(e1,e2); 
       
   }

}