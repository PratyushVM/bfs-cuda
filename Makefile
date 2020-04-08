CC = g++
NVCC = nvcc

all : bfs

bfs : obj/main.o obj/readgraph.o obj/printgraph.o obj/simple_bfs.o obj/init_depth.o obj/bfs_kernel.o
	$(NVCC) obj/main.o obj/readgraph.o obj/printgraph.o obj/simple_bfs.o obj/init_depth.o obj/bfs_kernel.o -o bfs

obj/main.o : main.cu      
	$(NVCC) -c main.cu -o obj/main.o 

obj/readgraph.o : src/readgraph.cpp
	$(CC) -c src/readgraph.cpp -o obj/readgraph.o  

obj/printgraph.o : src/printgraph.cpp
	$(CC) -c src/printgraph.cpp -o obj/printgraph.o

obj/simple_bfs.o : src/simple_bfs.cu 
	$(NVCC) -c src/simple_bfs.cu -o obj/simple_bfs.o

obj/init_depth.o : src/init_depth.cu
	$(NVCC) -c src/init_depth.cu -o obj/init_depth.o

obj/bfs_kernel.o : src/bfs_kernel.cu
	$(NVCC) -c src/bfs_kernel.cu -o obj/bfs_kernel.o