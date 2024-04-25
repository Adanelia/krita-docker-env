#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/find_default_container_file.inc

container_name=$(parseContainerArgs $*)
if [ -z ${container_name} ]; then
    exit 1
fi

tryStartContainer $container_name

${DOCKER_BINARY} exec -ti ${container_name} mkdir -p /home/appimage/.config/Code/User/
${DOCKER_BINARY} cp ~/.config/Code/User/settings.json ${container_name}:/home/appimage/.config/Code/User/settings.json
${DOCKER_BINARY} cp ~/.config/Code/User/keybindings.json ${container_name}:/home/appimage/.config/Code/User/keybindings.json

