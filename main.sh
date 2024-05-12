#! /bin/bash

source config.sh

getDate() {
    eval "date +'%Y-%m-%d %H:%M:%S'"
}

oldResult=$(curl -s "https://api.ipify.org/")
# Run this when program starts to ensure using right ip
intialDuckRes=$(curl -s "https://www.duckdns.org/update?domains=$DOMAIN&token=$API_TOKEN&ip=$oldResult")

if [[ $intialDuckRes != 'OK' ]]; then
    echo "$(getDate): Initial update to DuckDns failed"
else
    echo "$(getDate): Initial update to DuckDns success"
fi

while true; do

    newResult=$(curl -s "https://api.ipify.org/")
    if [[ $oldResult != $newResult ]]; then
        if [[ $newResult =~ '^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$' ]]; then
            duckResponse=$(curl -s "https://www.duckdns.org/update?domains=$DOMAIN&token=$API_TOKEN&ip=$newResult")
            if [[ $duckResponse != 'OK' ]]; then
                echo "$(getDate): Error updating the ip. Response: $duckResponse"
            else
                echo "$(getDate): Ip updated from $oldResult to $newResult"
                oldResult=$newResult
            fi
        else
            echo "$(getDate): Error with HTTP request: $newResult"
        fi
    fi
    sleep 30
done