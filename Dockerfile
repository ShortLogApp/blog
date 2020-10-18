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

COPY ./wrapper.js ./current/wrapper.js

ENV url http://localhost:2368

ENV GITHUB_TOKEN CHANGEME-token
ENV GITHUB_OWNER CHANGEME-owner
ENV GITHUB_REPO CHANGEME-repo
ENV GITHUB_BRANCH CHANGEME-branch
ENV GITHUB_DESTINATION CHANGEME-destination
ENV GITHUB_BASEURL CHANGEME-baseUrl
ENV GITHUB_USERELATIVEURLS false

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["node", "current/wrapper.js"]
