FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1

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
