FROM alpine:3.18.0@sha256:c0669ef34cdc14332c0f1ab0c2c01acb91d96014b172f1a76f3a39e63d1f0bda

WORKDIR /usr/src

RUN set -eux; \
    apk add --no-cache bash ffmpeg nginx supervisor

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN mkdir -p /var/log/supervisor; \
    mkdir -p /var/www/html; \
    addgroup -g $USER_GID $USERNAME; \
    adduser -D -u $USER_UID -G $USERNAME -s /bin/bash -h /home/$USERNAME $USERNAME; \
    chown $USERNAME /var/www/html;

COPY supervisord.conf entrypoint.sh ./
COPY profiles profiles
COPY player.html /var/www/html/index.html
COPY nginx.conf /etc/nginx/http.d/default.conf

ENV USER=$USERNAME

CMD ["./entrypoint.sh"]
