FROM docker:24.0.7 AS docker
FROM docker/compose:1.29.2 AS compose
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:453.0.0-alpine AS google-cloud-sdk
FROM node:18.16.0-slim AS node

FROM alpine:3.18

RUN mkdir -p /tmp/workspace \
    && mkdir -p /tmp/logs

RUN apk --no-cache add \
    git \
    curl \
    make \
    bash \
    libc6-compat \
    openssh \
    openssh-client \
    sudo \
    jq \
    gnupg

ENV DOCKER_BUILDKIT=1

COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=compose /usr/local/bin/docker-compose /bin/docker-compose
COPY --from=docker/buildx-bin:latest /buildx /usr/libexec/docker/cli-plugins/docker-buildx
COPY --from=google-cloud-sdk /google-cloud-sdk/bin/ /usr/local/bin/
COPY --from=google-cloud-sdk /google-cloud-sdk/lib/ /usr/local/lib/
COPY --from=google-cloud-sdk /google-cloud-sdk/platform/ /usr/local/platform/
COPY --from=google-cloud-sdk /google-cloud-sdk/.install/ /usr/local/.install/
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

RUN curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry \
    && chmod +x /usr/local/bin/retry
