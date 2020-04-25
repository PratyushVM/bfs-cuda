CC = g++
NVCC = nvcc

all : bfs

bfs : obj/main.o obj/readgraph.o obj/printgraph.o obj/simple_bfs.o obj/init_depth.o obj/bfs_kernel.o obj/check.o
	$(NVCC) obj/main.o obj/readgraph.o obj/printgraph.o obj/simple_bfs.o obj/init_depth.o obj/bfs_kernel.o obj/check.o -o bfs

obj/main.o : main.cu obj     
	$(NVCC) -c main.cu -o obj/main.o 

obj/readgraph.o : src/readgraph.cpp obj
	$(CC) -c src/readgraph.cpp -o obj/readgraph.o  

obj/printgraph.o : src/printgraph.cpp obj
	$(CC) -c src/printgraph.cpp -o obj/printgraph.o

obj/simple_bfs.o : src/simple_bfs.cu obj
	$(NVCC) -c src/simple_bfs.cu -o obj/simple_bfs.o

obj/init_depth.o : src/init_depth.cu obj
	$(NVCC) -c src/init_depth.cu -o obj/init_depth.o

obj/bfs_kernel.o : src/bfs_kernel.cu obj
	$(NVCC) -c src/bfs_kernel.cu -o obj/bfs_kernel.o

obj/check.o : src/check.cpp obj
	$(CC) -c src/check.cpp -o obj/check.o

obj : 
	mkdir obj

clean :
	rm obj/*.o ./bfs
	rmdir obj