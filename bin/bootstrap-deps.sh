#!/bin/bash

if [ ! -d ./persistent ]; then
    mkdir ./persistent
fi

./bin/bootstrap-krita-deps.sh

if [ ! -f ./persistent/qtcreator-package.tar.gz ]; then
    (
        cd ./persistent/
        wget https://files.kde.org/krita/build/qtcreator-package.tar.gz -O ./qtcreator-package.tar.gz || exit 1
    )
fi
