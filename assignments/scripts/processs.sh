#!/bin/sh

rm output

for i in ./* ; do
  if [ -d "$i" ]; then
    echo $i >> output
    param_file=${i}/params.txt
    cat $param_file >> output 
    echo "\n" >> output
  fi
done
