#!/bin/bash

image=$(mktemp --suffix=.png)
scrot --overwrite $image
blur_image $image -o $image -r 10 -s 0.7 -l 0.7
i3lock --image=$image --ignore-empty-password --show-failed-attempts
rm $image
