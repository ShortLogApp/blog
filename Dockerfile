FROM node:12-alpine3.12

ENV PYTHONUNBUFFERED=1
ENV NODE_ENV production
ENV GHOST_VERSION 3.35.5
ENV GHOST_CLI_VERSION 1.15.0
ENV GHOST_INSTALL /var/lib/ghost
ENV GHOST_CONTENT /var/lib/ghost/content

# Runtime config
ENV url http://localhost:2368
ENV server__port 2368
ENV storage__active gcs
ENV storage__gcs__bucket CHANGEME-bucket

ENV database__client mysql
ENV database__connection__host host.docker.internal
ENV database__connection__port 3306
ENV database__connection__user root
ENV database__connection__password ""
ENV database__connection__database shortlog_blog

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2' bash python3 make && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi

RUN set -eux; \
	npm install -g "ghost-cli@$GHOST_CLI_VERSION" ghost-v3-google-cloud-storage; \
	npm cache clean --force

RUN set -eux; \
	mkdir -p "$GHOST_INSTALL"; \
	chown node:node "$GHOST_INSTALL"; \
	su-exec node ghost install "$GHOST_VERSION" \
	    --url "$url" \
	    --port "$server__port" \
	    --ip 0.0.0.0 \
	    --db mysql \
	    "$([[ $NODE_ENV = development ]] && echo '--development')" \
	    --dbhost "$database__connection__host" \
	    --dbuser "$database__connection__user" \
	    --dbpass "$database__connection__password" \
	    --dbname "$database__connection__database" \
	    --no-prompt --no-stack --no-setup --no-start --dir "$GHOST_INSTALL"; \
	cd "$GHOST_INSTALL"; \
	su-exec node ghost config --ip 0.0.0.0 --port "$server__port" --no-prompt --db mysql --url "$url"; \
	su-exec node ghost config paths.contentPath "$GHOST_CONTENT"; \
# Install storage adapter
    su-exec node npm i ghost-v3-google-cloud-storage; \
    su-exec node mkdir -p "$GHOST_CONTENT/adapters/storage/gcs"; \
    su-exec node mv node_modules/ghost-v3-google-cloud-storage/* content/adapters/storage/gcs/; \
    #su-exec node npm i dtrace-provider ghost-ignition ghost-v3-google-cloud-storage
# make a config.json symlink for NODE_ENV=development (and sanity check that it's correct)
	su-exec node ln -s config.production.json "$GHOST_INSTALL/config.development.json"; \
	readlink -f "$GHOST_INSTALL/config.development.json"; \
	su-exec node yarn cache clean; \
	su-exec node npm cache clean --force; \
	npm cache clean --force; \
	rm -rv /tmp/yarn* /tmp/v8*

USER node

WORKDIR $GHOST_INSTALL

COPY ./content content

EXPOSE $PORT
EXPOSE $server__port

RUN printf '#! /bin/bash\nserver__port=${PORT:=$server__port} node current/index.js\n' > run.sh && chmod u+x run.sh
CMD "./run.sh"
