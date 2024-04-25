#!/bin/bash

function tryCreateXAuthCookieFile {
    if [[ ! -e /tmp/krita-docker-xauth ]] ||
        ! cmp -s $XAUTHORITY /tmp/krita-docker-xauth ; then

        echo "### Forwarding XAUTH cookie..."
        cat $XAUTHORITY > /tmp/krita-docker-xauth
    fi
}