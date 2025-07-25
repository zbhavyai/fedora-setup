#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Launch Google Chrome on a virtual X session with VNC session to remotely connect to it

set -euo pipefail

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Launch Google Chrome on a virtual X session with VNC session to remotely connect to it."
    echo
    echo "Especially helpful to get UI access at the customer's machine. This script handles everything from launching virtual X session, launching Chrome, and when you are done, just press Ctrl+C and the script will handle the clean-up too."
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -s|--start     start the virtual X session, VNC server, Openbox session, and Google Chrome."
    echo "    -h|--help      print this Help."
    echo
    echo "Note:"
    echo "    You would need to SSH with port 6100 forwarded to use this script."
    echo "    This avoids forwarding the port in the firewall."
    echo
    echo
    echo "Example:"
    echo "    ssh -L 6100:localhost:6100 root@172.26.0.XXX"
    echo "    ${0} --start"
    echo "    ... and then connect to Chrome session using VNC client from your laptop at the URL 127.0.0.1:6100"
    echo "    ... once you are done, press Ctrl+C"
    echo
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "\n$1."
}

# main function
# -------------------------------------------------------------------------------------
function start() {
    # ensure dependencies are installed
    prettyPrint "[INFO] Installing required packages"
    sudo dnf install --quiet --assumeyes xorg-x11-server-Xvfb x11vnc openbox google-chrome

    # start virtual framebuffer
    prettyPrint "[INFO] Starting Xvfb on display $DISPLAY"
    /usr/bin/Xvfb $DISPLAY -screen 0 $RESOLUTION &>/dev/null &
    PID_XVFB=$!
    sleep 2

    # start vnc server on the x session
    prettyPrint "[INFO] Starting x11vnc on port $RFBPORT"
    /usr/bin/x11vnc -quiet -display $DISPLAY -rfbport $RFBPORT -nopw -forever -shared -ncache_cr -always_inject -xkb -repeat -skip_lockkeys &>/dev/null &
    PID_X11VNC=$!

    # start openbox-session
    prettyPrint "[INFO] Starting openbox session"
    DISPLAY=$DISPLAY /usr/bin/openbox-session &
    PID_OPENBOX=$!

    # launch google chrome
    prettyPrint "[INFO] Launching Google Chrome"
    DISPLAY=$DISPLAY /usr/bin/google-chrome --no-sandbox --disable-accelerated-2d-canvas --disable-gpu --disable-smooth-scrolling --start-maximized &>/dev/null &
    PID_CHROME=$!

    # cleanup function
    cleanup() {
        prettyPrint "[INFO] Caught signal, cleaning up"
        kill -9 $PID_XVFB $PID_X11VNC $PID_OPENBOX $PID_CHROME 2>/dev/null || true
        prettyPrint "[INFO] All processes terminated"
        exit 0
    }

    # trap ctrl+c and termination signals
    trap cleanup SIGINT SIGTERM

    prettyPrint "[INFO] Headless Chrome VNC session is running on port $RFBPORT"
    prettyPrint "Press Ctrl+C to stop"

    # wait indefinitely
    wait
}

# driver code
# -------------------------------------------------------------------------------------
DISPLAY=":200"
RESOLUTION="1920x1080x24"
RFBPORT=6100

if [ $# -eq 0 ]; then
    Help
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        Help
        exit
        ;;
    -s | --start)
        start
        exit
        ;;
    *)
        prettyPrint "[FATAL] Invalid option \"$1\". Use --help for more information"
        exit 1
        ;;
    esac
done
