FROM alpine:3.18.2@sha256:25fad2a32ad1f6f510e528448ae1ec69a28ef81916a004d3629874104f8a7f70

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
