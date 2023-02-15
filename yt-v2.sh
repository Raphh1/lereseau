#!/bin/bash

cd /srv/yt
while true
do
    while IFS="" read -r p || [ -n "$p" ]
    do
        if [[ $p = https://www.youtube.com/watch?v=* ]]
        then
            bash /srv/yt/yt.sh $p
        fi

        grep -v "$p" /srv/yt/dl_input > /srv/yt/temp
        mv /srv/yt/temp /srv/yt/dl_input
        chmod o+w /srv/yt/dl_input
    done < /srv/yt/dl_input

    sleep 5
done