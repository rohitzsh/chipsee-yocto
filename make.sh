#!/bin/bash
set -e -o pipefail

cd "$(dirname "$0")"

NAME=chipsee-yocto
VERSION=latest

opt="$1";

docker_cmd() {
    local cmd=$*
    docker-compose build
    docker run --rm -it \
            --privileged \
            --cap-add=ALL \
            --device=/dev/kvm \
            --volume "$PWD"/build:/opt/yocto/build \
            --volume /lib/modules:/lib/modules \
            --name $NAME ${NAME}:${VERSION} \
            "$cmd"
}

clean_build() {
    for item in build/*; do
        if [[ ! "$item" =~ (downloads|sstate-cache) ]]; then
            rm -rf "$item"
        fi
    done
}

if [ -z "$opt" ];then
    echo >&2 "
    Usage: ./make.sh [OPTIONS]

    Options:
        build       builds OS 
        clean       cleans build folder (except downloads and sstate-cache directory) 
        test        runs OS using qemu
        CMD         any custom command to be executed by docker container"
    exit 1
fi

case "$opt" in
    "build" )
        docker_cmd bitbake core-image-minimal
        ;;
    "clean" )
        clean_build
        ;;
    "test" )
        docker_cmd runqemu qemuarm nographic
        ;;
    *)
        docker_cmd "$@"
    ;;
esac