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

RUN npm i dtrace-provider ghost-ignition ghost-v3-google-cloud-storage

#RUN mkdir -p content.orig/adapters/storage && \
#    cp -r node_modules/ghost-storage-github content.orig/adapters/storage/ghost-storage-github

RUN mkdir -p content.orig/adapters/storage/gcs && \
    mv node_modules/ghost-v3-google-cloud-storage/* content.orig/adapters/storage/gcs/

RUN mv ./current/index.js ./current/origIndex.js
COPY ./wrapper.js ./current/index.js

ENV url http://localhost:2368

ENV GCS_BUCKET CHANGEME-bucket
