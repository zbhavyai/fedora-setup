#!/bin/bash
#
# author        : Jason Kim
# description   : Continuously print CPU/Memory/GPU stats on the terminal

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Continuously print CPU/GPU/Memory stats on the terminal. Note that its unrelated to our Userful Infinity Monitoring application."
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -e    start the monitoring"
    echo "    -h    show this help message"
    echo
    echo
    echo "Examples:"
    echo "-> Run the script"
    echo "    ${0} -s"
    echo
}

# start monitoring
# -------------------------------------------------------------------------------------
function startMonitoring() {
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
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":hs" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    s)
        startMonitoring
        exit
        ;;
    \?)
        prettyPrint "[ERROR] Invalid option"
        Help
        exit
        ;;
    esac
done

if ((OPTIND == 1)); then
    Help
    exit
fi
