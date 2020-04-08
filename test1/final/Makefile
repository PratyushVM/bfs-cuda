CC = g++
NVCC = nvcc

all : bfs

bfs : obj/main.o obj/readgraph.o obj/printgraph.o obj/simple_bfs.o obj/init_depth.o
	$(NVCC) obj/main.o obj/readgraph.o obj/printgraph.o obj/simple_bfs.o obj/init_depth.o -o bfs

obj/main.o : main.cpp      
	$(NVCC) -c main.cpp -o obj/main.o 

obj/readgraph.o : src/readgraph.cpp
	$(CC) -c src/readgraph.cpp -o obj/readgraph.o  

obj/printgraph.o : src/printgraph.cpp
	$(CC) -c src/printgraph.cpp -o obj/printgraph.o

obj/simple_bfs.o : src/simple_bfs.cpp
	$(NVCC) -c src/simple_bfs.cpp src/bfs_kernel.cu -o obj/simple_bfs.o

obj/init_depth.o : src/init_depth.cu
	$(NVCC) -c src/init_depth.cu -o obj/init_depth.o