#! /bin/bash

# set session name
s_name=$1

if [ -z "$s_name" ]; then
 echo "usage) $0 sessionname command" 
 screen -ls 
 exit
fi

shift

# define window list
#  - window name or window index

if [ -z "$w_names" ]; then
w_names=( \
         'Web01' \
         'DB01' \
        )
fi



i=1
while [ $i -le ${#w_names[@]} ]
do
    wid=$i
    idx=`expr $i - 1`
    echo "Command to: ${w_names[$idx]}"
	screen -X -S $s_name -p ${w_names[$idx]} stuff "$@$(printf \\r)"
    i=`expr $i + 1`
done
