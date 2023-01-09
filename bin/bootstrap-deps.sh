#!/bin/bash

if [ ! -d ./persistent ]; then
    mkdir ./persistent
fi

if [ ! -f ./persistent/krita-appimage-deps.tar ]; then
    (
        cd ./persistent/

        if wget --version | grep \\-lz > /dev/null; then
            wget --compression=auto https://binary-factory.kde.org/job/Krita_Nightly_Appimage_Dependency_Build/lastSuccessfulBuild/artifact/krita-appimage-deps.tar || exit 1
        else
            curl -LO --compressed https://binary-factory.kde.org/job/Krita_Nightly_Appimage_Dependency_Build/lastSuccessfulBuild/artifact/krita-appimage-deps.tar || exit 1
        fi
    )
fi

if [ ! -f ./persistent/qtcreator-package.tar.gz ]; then
    (
        cd ./persistent/
        wget https://files.kde.org/krita/build/qtcreator-package.tar.gz -o qtcreator-package.tar.gz || exit 1
    )
fi
