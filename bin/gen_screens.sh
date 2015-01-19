#!/bin/bash


function make_screens {
i=1
while [ $i -le ${#hosts[@]} ]
do
    #wid=`expr $i + 1`
    wid=$i
    idx=`expr $i - 1`
    echo "Now Generating: screen[$wid]: ${w_names[$idx]}"
    if [ $wid -eq 1 ]; then
		screen -d -m -S $s_name -t $s_name
		screen -X -S $s_name -p $wid title ${w_names[$idx]}
    else
		screen -X -S $s_name screen -t ${w_names[$idx]} $wid
    fi
    i=`expr $i + 1`
done
}


function command_send_all {
i=1
while [ $i -le ${#hosts[@]} ]; do
    wid=$i
    idx=`expr $i - 1`
    echo "Now Send Command: screen[$wid]: ${w_names[$idx]} : ${hosts[$idx]}"
    
    screen -X -S $s_name -p $wid stuff "$(eval echo $@)$(printf \\r)"
    i=`expr $i + 1`
done
}



  #### MAIN ####


# input screen session name
echo -n "session name: "
read s_name

# input server password
echo -n "User Name: "
read user
#echo ""
echo -n "Password for $user: "
read -s passwordnormaluser
echo ""
echo -n "Password for Root User: "
read -s passwordrootuser
echo ""


# host list
hosts=( \
        '192,168.5.11' \
        '192,168.5.12' \
      )

# window name
w_names=( \
        'Web01' \
        'DB01' \
      )

echo -n "Do you want to generate screens? [yes/no]: "
read flg_makescreen
[ "$flg_makescreen" = "yes" ] && make_screens

# set target host variable
command_send_all 'export TARGET_HOST=${hosts[$idx]}'
usleep 100000

# login
command_send_all 'ssh $user@${hosts[$idx]}'
usleep 2000000
command_send_all "${passwordnormaluser}"
usleep 1000000

# su root
command_send_all "su -"
usleep 1000000
command_send_all "${passwordrootuser}"


# attach screen
#screen -r $s_name -p $i 

