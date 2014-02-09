#!/bin/bash

for item in `ls ../EricMurphy/Pictures`; do
  echo $item
done

python3 main.py upload ../EricMurphy/Pictures/pic1.jpg >> imgur-link
