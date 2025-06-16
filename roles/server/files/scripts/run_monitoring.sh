#!/bin/bash

cnt=0
head_print_every=50
interval=5

while true; do
    cur_date=$(date +"%b-%d %T")
    #open_files=$(lsof -p `pidof userful-veo` | wc -l)
    open_files=0
    cpu=$(top -n1 | grep '%Cpu' | awk '{print $2 "%"}')
    mem=$(top -n1 | grep 'MiB Mem' | awk '{print $4 "/" $8}')
    gpu=$(nvidia-smi dmon -c 1 | grep -v "#" | awk '{print $5"/"$6"/"$7"/"$8}')

    if [ $((cnt % head_print_every)) == 0 ]; then
        echo -e "date\t\tveo-openfiles\tcpu\tmem\t\tsm/mem/enc/dec"
    fi
    echo -e "$cur_date\t$open_files\t\t$cpu\t$mem\t$gpu"
    cnt=$((cnt + 1))
    sleep $interval
done
