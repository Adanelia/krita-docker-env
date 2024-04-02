#!/bin/bash

set -e

usage=\
"Usage: $(basename "$0") [OPTION]...\n
Bootstrap deps for building the krita in the docker image\n
\n
where:\n
    -h,      --help              show this help text\n
    -a ARCH, --android=ARCH      target architecture ('x86_64', 'armeabi-v7a', 'arm64-v8a')\n
    -p DIR,  --prefix=DIR        working directory for the environment setup
\n
"

TARGET_ANDROID_ABI_ARG=
WORK_DIR=./persistent/deps/

# Call getopt to validate the provided input.
options=$(getopt -o "ha:p:" --long "help android: prefix:" -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
    -a | --android)
        TARGET_ANDROID_ABI_ARG="--android-abi $2"
        ;;
    -p | --prefix)
        WORK_DIR=$2
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

set -ex

if [ ! -d $WORK_DIR ]; then
    mkdir -p $WORK_DIR
fi

if [ ! -d $WORK_DIR/_install ]; then
    (
        cd $WORK_DIR

        if [ ! -d ./krita-deps-management ]; then
            git clone https://invent.kde.org/dkazakov/krita-deps-management.git
        else
            (
                cd ./krita-deps-management
                git pull
            )
        fi
        if [ ! -d ./krita-deps-management/ci-utilities ]; then
            git clone https://invent.kde.org/dkazakov/ci-utilities.git -b work/split-ci-branch krita-deps-management/ci-utilities
        else
            (
                cd ./krita-deps-management/ci-utilities
                git pull
            )
        fi
        python3 -m venv PythonEnv --upgrade-deps
        . PythonEnv/bin/activate
        python -m pip install -r krita-deps-management/requirements.txt
        python krita-deps-management/tools/setup-env.py --full-krita-env -v PythonEnv $TARGET_ANDROID_ABI_ARG
    )
fi
