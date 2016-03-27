#!/usr/bin/bash
mkdir www
for ((i=0;i<100;i++))
do
  wget https://wikipedia.org/wiki/Special:Random -O "./www/${i}.html"
done
