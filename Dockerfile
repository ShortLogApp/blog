FROM ghost:3-alpine

## Installl Python3 for ghost-storage-github dependency
#
# NOTE(cory): Taken from https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/blob/master/Dockerfile

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache python3 make sudo && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

# End Python3 install
#

ENV USER=ghost
ENV UID=12345

RUN adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "node" \
    --uid "$UID" \
    "$USER"

# Allow the /var/lib/ghost owner's group to write to all dirs in /var/lib/ghost
RUN find ./ -type d -exec chmod 00775 {} \;

# Allow the /var/lib/ghost owner's group to write to most of the files in /var/lib/ghost
RUN find ./ ! -path "./versions/*" -type f -exec chmod 664 {} \;

#RUN su ghost -c "ghost update --force"

WORKDIR /var/lib/ghost

RUN npm i dtrace-provider ghost-ignition ghost-storage-github

RUN mkdir -p content.orig/adapters/storage && \
    cp -r node_modules/ghost-storage-github content.orig/adapters/storage/ghost-storage-github

#ENTRYPOINT []
#CMD ["node", "current/index.js"]

#RUN npm i @tryghost/errors bluebird

##
##COPY content /var/lib/ghost/content
##
##ENV url http://localhost:8080
##ENV database__client mysql
##ENV database__connection__host host.docker.internal
##ENV database__connection__port 3306
##ENV database__connection__user root
##ENV database__connection__password ""
##ENV database__connection__database shortlog_blog
##
##ENV GOOGLE_CLOUD_PRIVATE_KEY_PATH google-cloud-key.json
##ENV GOOGLE_CLOUD_PRIVATE_KEY CHANGEME
##ENV GOOGLE_CLOUD_CLIENT_EMAIL CHANGEME
##ENV GOOGLE_CLOUD_CLIENT_ID CHANGEME
##
##CMD echo "$GOOGLE_CLOUD_KEY" > "$GOOGLE_CLOUD_KEY_PATH" && node current/index.js
#
#COPY content /var/lib/ghost/content
#

ENV url http://localhost:2368
ENV storage__active ghost-storage-github
ENV storage__ghost-storage-github__token CHANGEME-token
ENV storage__ghost-storage-github__owner CHANGEME-owner
ENV storage__ghost-storage-github__repo CHANGEME-repo
ENV storage__ghost-storage-github__branch CHANGEME-branch
ENV storage__ghost-storage-github__destination CHANGEME-destination
ENV storage__ghost-storage-github__baseUrl CHANGEME-baseUrl
ENV storage__ghost-storage-github__useRelativeUrls false
