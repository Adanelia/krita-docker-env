#!/bin/bash

usage=\
"Usage: $(basename "$0") [OPTION]...\n
Bootstrap deps for building the docker image\n
\n
where:\n
    -h,        --help              show this help text\n
    -a ARCH,   --android=ARCH      target architecture ('x86_64', 'armeabi-v7a', 'arm64-v8a')\n
    -b BRANCH, --branch=BRANCH     a custom branch for fetching Krita deps\n
\n
"

ANDROID_ARG=
BRANCH_ARG=

# Call getopt to validate the provided input.
options=$(getopt -o "ha:b:" --long "help android: branch:" -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
    -b | --branch)
        BRANCH_ARG="--branch=$2"
        ;;
    -a | --android)
        ANDROID_ARG="--android=$2"
        ;;
    -h | --help)
        echo -e $usage >&2
        exit 1
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ ! -d ./persistent ]; then
    mkdir ./persistent
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$DIR/bootstrap-krita-deps.sh $ANDROID_ARG $BRANCH_ARG

if [ ! -f ./persistent/qtcreator-package.tar.gz ]; then
    (
        cd ./persistent/
        wget https://files.kde.org/krita/build/qtcreator-package.tar.gz -O ./qtcreator-package.tar.gz || exit 1
    )
fi
