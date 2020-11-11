# To use:
#
# Try to get this rubbish running
# xhost +
#
# docker run --rm -t -i \
#       -v /tmp/.X11-unix:/tmp/.X11-unix \
#       -e DISPLAY=$DISPLAY \
#	--device /dev/dri \
#       imageName

# Base docker image
FROM ubuntu:focal

RUN apt install -y vim-tiny sudo

# Old qt4
COPY files/sources.list.d/rock-core-ubuntu-qt4.list \
    /etc/apt/sources.list.d/rock-core-ubuntu-qt4.list

RUN apt update --allow-unauthenticated

COPY simple-ide_1-0-1-rc1_amd64.deb .

RUN apt install -y ./simple-ide_1-0-1-rc1_amd64.deb

# REMOVE simple-ide_1-0-1-rc1_amd64.deb .

COPY files/entrypoint.sh /entrypoint

## ENTRYPOINT [ "xeyes" ]
