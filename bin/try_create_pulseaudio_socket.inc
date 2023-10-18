#!/bin/bash

function tryCreatePulseaudioSocket {
    if [[ ! -e /tmp/pulseaudio-docker.socket ]]; then
        echo "### Creating a pulseaudio socket..."
        pactl load-module module-native-protocol-unix socket=/tmp/pulseaudio-docker.socket

        cat <<EOF > /tmp/pulseaudio.client.conf
default-server = unix:/tmp/pulseaudio-docker.socket
# Prevent a server running in the container
autospawn = no
daemon-binary = /bin/true
# Prevent the use of shared memory
enable-shm = false
EOF
    fi
}