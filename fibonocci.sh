#!/bin/bash

a=1
b=1
echo "a: $a - b: $b"
for I in {1..8}; 
  do 
    c=a
    echo "c: $c"
    b=$a
    b=$(($a+$c))
    echo $b
  done 
