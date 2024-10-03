#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/find_default_container_file.inc

container_name=$(parseContainerArgs $*)
if [ -z ${container_name} ]; then
    exit 1
fi

set -e

${DOCKER_BINARY} cp ./data/intel/ ${container_name}:/home/appimage/
${DOCKER_BINARY} exec -ti -u root ${container_name} /home/appimage/intel/install-drivers.sh
