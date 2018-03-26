FROM alpine

RUN mkdir -p /tmp/build/workspace

RUN apk --no-cache add git curl make

COPY --from=docker:17.12 /usr/local/bin/docker /bin/docker
COPY --from=docker/compose:1.20.1 /usr/local/bin/docker-compose /usr/local/bin/docker-compose

