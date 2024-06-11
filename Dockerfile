FROM docker:25.0.0 AS docker
FROM docker/compose:1.29.2 AS compose
FROM hairyhenderson/gomplate:v3.11.7 AS gomplate
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:480.0.0-alpine AS google-cloud-sdk
# FROM node:current-alpine3.18 AS node

# FROM alpine:3.18
FROM node:current-alpine3.18

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
COPY --from=docker /usr/local/libexec/docker/cli-plugins/docker-compose /usr/libexec/docker/cli-plugins/
RUN ln -s /usr/libexec/docker/cli-plugins/docker-compose /bin/docker-compose
COPY --from=docker /usr/local/libexec/docker/cli-plugins/docker-buildx /usr/libexec/docker/cli-plugins/
COPY --from=google-cloud-sdk /google-cloud-sdk/bin/ /usr/local/bin/
COPY --from=google-cloud-sdk /google-cloud-sdk/lib/ /usr/local/lib/
COPY --from=google-cloud-sdk /google-cloud-sdk/platform/ /usr/local/platform/
COPY --from=google-cloud-sdk /google-cloud-sdk/.install/ /usr/local/.install/
COPY --from=gomplate /gomplate /bin/gomplate

RUN curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry \
    && chmod +x /usr/local/bin/retry
