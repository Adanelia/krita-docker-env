#!/bin/bash

set -ex

if [ ! -d ./persistent/deps ]; then
    mkdir ./persistent/deps
fi

if [ ! -d ./persistent/_install ]; then
    (
        cd ./persistent/deps

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
        python krita-deps-management/tools/setup-env.py --full-krita-env -v PythonEnv
    )
fi
