#!/bin/bash
set -e

SKY_IP=$(jq --raw-output ".sky_ip" options.json)

# Read from STDIN aliases to send shutdown
while read -r input; do
    # remove json stuff
    input="$(echo "$input" | jq --raw-output '.')"
    echo "[Info] Read input: $input"

    # Check for the correct command
    if [ "$input" != "power" ]; then
		# Not the correct command
        continue
    else
        # The correct command
        eval sky-remote-cli "$SKY_IP" power
        echo "[Info] power command sent"
    fi

done