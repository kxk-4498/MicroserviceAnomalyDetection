#!/bin/sh
cp --backup=t data.json ./hubble_data/
rm data.json
hubble observe --follow -o json > data.json

