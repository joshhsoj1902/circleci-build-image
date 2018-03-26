FROM alpine

RUN mkdir -p /tmp/build/workspace

RUN apk --no-cache add git curl make

COPY --from=docker:17.12 /usr/local/bin/docker /bin/docker

# Docker-compose 
RUN apk add --no-cache python2
RUN apk add --no-cache --virtual build-deps py-pip
RUN pip install --trusted-host pypi.python.org docker-compose

