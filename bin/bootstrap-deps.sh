#!/bin/bash

usage=\
"Usage: $(basename "$0") [OPTION]...\n
Bootstrap deps for building the docker image\n
\n
where:\n
    -h,      --help              show this help text\n
    -a ARCH, --android=ARCH      target architecture ('x86_64', 'armeabi-v7a', 'arm64-v8a')\n
\n
"

DEPS_EXTRA_ARGS=

# Call getopt to validate the provided input.
options=$(getopt -o "ha:" --long "help android:" -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
    -a | --android)
        DEPS_EXTRA_ARGS=--android=$2
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

$DIR/bootstrap-krita-deps.sh $DEPS_EXTRA_ARGS

if [ ! -f ./persistent/qtcreator-package.tar.gz ]; then
    (
        cd ./persistent/
        wget https://files.kde.org/krita/build/qtcreator-package.tar.gz -O ./qtcreator-package.tar.gz || exit 1
    )
fi
