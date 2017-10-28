#!/bin/sh

for f in *.caf
do 
    ffmpeg -i $f -map_metadata 0 ${f%.*}.wav
done


for f in *.3gp
do 
    ffmpeg -i $f -map_metadata 0 ${f%.*}.wav
done
