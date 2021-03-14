#!/bin/bash

for f in `ls -ap | grep -v /`; do
    echo 'hoge'$f
done
