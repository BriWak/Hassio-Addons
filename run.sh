#!/bin/bash
set -e

SKY_IP=$(jq --raw-output ".sky_ip" options.json)

commands="sky power tvguide home boxoffice services search interactive sidebar up down left right select channelup channeldown i backup dismiss text help play pause rewind fastforward stop record red green yellow blue 0 1 2 3 4 5 6 7 8 9"

# Read from STDIN aliases to send command
while read -r input; do
    
    # remove json stuff
    input="$(echo "$input" | jq --raw-output '.')"
    echo "[Info] Read input: $input"

        # Check for a valid command
        if [[ ! " $commands " =~ " $input " ]]; then
            # Not a valid command
            echo "[Warn] $input is not a valid command"
            continue
        else
            # Valid command
            eval sky-remote-cli "$SKY_IP" "$input"
            echo "[Info] $input command sent"
        fi
done