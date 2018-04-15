FROM alpine:latest@sha256:7df6db5aa61ae9480f52f0b3a06a140ab98d427f86d8d5de0bedab9b8df6b1c0

RUN mkdir -p /tmp/workspace \
 && mkdir -p /tmp/logs

RUN apk --no-cache add git curl make bash

COPY --from=docker:17.12 /usr/local/bin/docker /bin/docker

# Docker-compose 
RUN apk add --no-cache python2
RUN apk add --no-cache --virtual build-deps py-pip
RUN pip install --trusted-host pypi.python.org docker-compose

RUN curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry \
 && chmod +x /usr/local/bin/retry
