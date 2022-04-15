#!/bin/sh
cp --backup=t data.txt ./hubble_data/
rm data.txt
hubble observe --follow -n sock-shop -o json > data.txt &

