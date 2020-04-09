# bfs-cuda
Implementation of simple parallel Breadth-first traversal algorithm in CUDA.

## Execution:
```
To build the project, run :
make

```
```

To run the algorithm on graphs from standard input:
./bfs <number of vertices> <number of edges> <source vertex>
<end of edge 0> <end of edge 0>
<end of edge 1> <end of edge 1>
<end of edge 2> <end of edge 2>
...

```

## Sample Input
```
./bfs 5 4 2 0 1 1 2 2 3 3 4
```
```
Output :

The depth of vertex 0 is 2
The depth of vertex 1 is 1
The depth of vertex 2 is 0
The depth of vertex 3 is 1
The depth of vertex 4 is 2

```





