#!/bin/bash
cd /tileserver-gl
echo "Starting xvfb with 3 second delay"
xvfb-run --server-args=":99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset" node . --port 80 --config config.json --verbose
