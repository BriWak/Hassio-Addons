#!/bin/bash
set -e

in_array () {
    local somearray=${1}[@]
    shift
    for SEARCH_VALUE in "$@"; do
        FOUND=false
        for ARRAY_VALUE in ${!somearray}; do
            if [[ $ARRAY_VALUE == $SEARCH_VALUE ]]; then
                FOUND=true
                break
            fi
        done
        if ! $FOUND; then
            return 1
        fi
    done
    return 0
}

SKY_IP=$(jq --raw-output ".sky_ip" options.json)

commands="sky power tvguide home boxoffice services search interactive sidebar up down left right select channelup channeldown i backup dismiss text help play pause rewind fastforward stop record red green yellow blue 0 1 2 3 4 5 6 7 8 9"

# Read from STDIN aliases to send command
while read -r input; do
    input="$input"
    # remove json stuff
    input="$(echo "$input" | jq --raw-output '.')"
    echo "$(date "+%F %T") [Info] Read input: $input"

    # Check for a valid command
    if ! in_array commands $input ; then
        # Not a valid command
        echo "$(date "+%F %T") [Error] $input is not a valid command"
        continue
    else
        # Valid command
        eval sky-remote-cli "$SKY_IP" "$input"
        echo "$(date "+%F %T") [Info] $input command sent"
    fi
done