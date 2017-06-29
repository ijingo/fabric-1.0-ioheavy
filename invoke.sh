#!/usr/bin/env bash

step=2000
total=1600000

j=0
for i in `seq 800000 $step $total`
do
  node invoke.js $i $step &>> invoke.log
  echo finished key-$i
done
