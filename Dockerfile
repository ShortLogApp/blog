FROM ghost:3-alpine

# Install Python3 for ghost-storage-github dependency
#
# NOTE(cory): Taken from https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/blob/master/Dockerfile

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache python3 make sudo && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi

# End Python3 install

WORKDIR /var/lib/ghost

RUN npm i dtrace-provider ghost-ignition ghost-storage-github

RUN mkdir -p content.orig/adapters/storage && \
    cp -r node_modules/ghost-storage-github content.orig/adapters/storage/ghost-storage-github

ENV url http://localhost:2368
ENV storage__active ghost-storage-github
ENV storage__ghost-storage-github__token CHANGEME-token
ENV storage__ghost-storage-github__owner CHANGEME-owner
ENV storage__ghost-storage-github__repo CHANGEME-repo
ENV storage__ghost-storage-github__branch CHANGEME-branch
ENV storage__ghost-storage-github__destination CHANGEME-destination
ENV storage__ghost-storage-github__baseUrl CHANGEME-baseUrl
ENV storage__ghost-storage-github__useRelativeUrls false
