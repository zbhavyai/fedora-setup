#!/bin/bash
set -euo pipefail

# CONFIG
DISPLAY=":200"
RESOLUTION="1920x1080x24"
RFBPORT=6100

# ensure dependencies are installed
echo "[INFO] Installing required packages..."
sudo dnf install --quiet --assumeyes xorg-x11-server-Xvfb x11vnc openbox google-chrome

# start virtual framebuffer
echo "[INFO] Starting Xvfb on display $DISPLAY..."
/usr/bin/Xvfb $DISPLAY -screen 0 $RESOLUTION &>/dev/null &
PID_XVFB=$!
sleep 2

# start vnc server on the x session
echo "[INFO] Starting x11vnc on port $RFBPORT..."
/usr/bin/x11vnc -quiet -display $DISPLAY -rfbport $RFBPORT -nopw -forever -shared -ncache_cr -always_inject -xkb -repeat -skip_lockkeys &>/dev/null &
PID_X11VNC=$!

# start openbox-session
echo "[INFO] Starting openbox session..."
DISPLAY=$DISPLAY /usr/bin/openbox-session &
PID_OPENBOX=$!

# launch google chrome
echo "[INFO] Launching Google Chrome..."
DISPLAY=$DISPLAY /usr/bin/google-chrome --no-sandbox --disable-accelerated-2d-canvas --disable-gpu --disable-smooth-scrolling --start-maximized &>/dev/null &
PID_CHROME=$!

# cleanup function
cleanup() {
    echo "[INFO] Caught signal, cleaning up..."
    kill -9 $PID_XVFB $PID_X11VNC $PID_OPENBOX $PID_CHROME 2>/dev/null || true
    echo "[INFO] All processes terminated."
    exit 0
}

# trap ctrl+c and termination signals
trap cleanup SIGINT SIGTERM

echo -e "\n\n[INFO] Headless Chrome VNC session is running on port $RFBPORT.\n\n"
echo "Press Ctrl+C to stop."

# wait indefinitely
wait
