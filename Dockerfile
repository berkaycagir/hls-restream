FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b

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
