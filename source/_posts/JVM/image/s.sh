#!/bin/sh
for file in $(ls *.png)
do
    new=`echo $file | sed 's/^pic/jvm/g'`
    mv $file $new
    echo $file
done
