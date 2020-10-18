#!/usr/bin/env bash

docker build -t shortlog-blog .
docker run --rm -v "$(pwd)"/content:/var/lib/ghost/content -p 8080:2368 -it shortlog-blog
