#!/bin/bash
daemon /usr/bin/Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset
echo "Waiting 3 seconds for xvfb to start..."
sleep 3

export DISPLAY=:99.0

cd /tileserver-gl
node . --port 80 --config config.json --verbose

#start-stop-daemon --stop --pidfile ~/xvfb.pid # stop xvfb when exiting
#rm ~/xvfb.pid
