#!/bin/bash

for ((i=0;i<10;i++)); do
./bfs 37700 289003 $i
echo $i"th iteration over"
done