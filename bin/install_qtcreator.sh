#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/find_default_container_file.inc

container_name=$(parseContainerArgs $*)
if [ -z ${container_name} ]; then
    exit 1
fi

tryStartContainer $container_name
if [ -f ${DIR}/../persistent/qtcreator-package.tar.gz ]; then
    ${DOCKER_BINARY} exec -ti ${container_name} tar xzfv /home/appimage/persistent/qtcreator-package.tar.gz -C /home/appimage
else
    echo "No qtcreator-package.tar.gz found in persitent dir. Rerun bootstrap-deps.sh script"
fi
