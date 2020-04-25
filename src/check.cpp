#include<bits/stdc++.h>
#include"../include/graph.h"


void check(graph *cpu_g,pii *c_edgelist, int start)
{
    list<int>* adj; //declaring adjacency matrix
    adj = new list<int>[cpu_g->v];

    int t1,t2;

    // adding the edges from edgelist given as input
    for(int i=0;i<cpu_g->e;i++)
    {
        t1 = c_edgelist[i].first;
        t2 = c_edgelist[i].second;
        adj[t1].pb(t2);
        adj[t2].pb(t1);
    }

    int visit[cpu_g->v] = {0}; // declaring visit array
    int level[cpu_g->v] = {0}; //declaring level array

    list<int> queue;

    int s;
    
    visit[start] = 1;
    queue.pb(start);

    while(!queue.empty())
    {
        s = queue.front();
        queue.pop_front();

        for(auto i = adj[s].begin();i!=adj[s].end();i++)
        {
            if(!visit[*i])
            {
                level[*i] = level[s] + 1;
                visit[*i] = 1;
                queue.pb(*i);
            }
        }
    }

    int flag=0;

    for(int i=0;i<cpu_g->v;i++)
    {
        if(cpu_g->depth[i] != level[i])
        {
            flag++;
            printf("Diff : node id %d - depth - %d and level - %d\n",i,cpu_g->depth[i],level[i]);
        }
    }

    if(flag == 0)
    printf("Passed correctness check\n");
    else
    printf("Failed correctness check\n");

}