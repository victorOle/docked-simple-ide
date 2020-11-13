# See associated Run-docker script for run magic

# Base docker image
FROM ubuntu:focal

# Need old qt4
COPY files/sources.list.d/rock-core-ubuntu-qt4.list \
    /etc/apt/sources.list.d/rock-core-ubuntu-qt4.list

COPY simple-ide_1-0-1-rc1_amd64.deb .

# Update with  --allow-unauthenticated since we have
# had problems with the ppa repo and we just want to get
# it running

RUN apt update --allow-unauthenticated \
 && apt install -y --no-install-recommends \
    vim-tiny sudo \
 && apt install -y --no-install-recommends \
    ./simple-ide_1-0-1-rc1_amd64.deb \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf simple-ide_1-0-1-rc1_amd64.deb

COPY files/entrypoint.sh /entrypoint

## ENTRYPOINT [ "program" ]
