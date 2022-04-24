#!/bin/sh
cp --backup=t data.txt ./hubble_data/
rm data.txt
hubble observe --follow  > data.txt

