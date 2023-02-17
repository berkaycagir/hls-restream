# hls-restream

[![Build, publish, cleanup](https://github.com/berkaycagir/hls-restream/actions/workflows/build_publish.yml/badge.svg)](https://github.com/berkaycagir/hls-restream/actions/workflows/build_publish.yml)

Restream live content as HLS using ffmpeg in Docker. This fork removes transcoding profiles and adds an audio-only option.

## Usage

You need to have Docker & Docker Compose installed.

1. Clone this repository:

```sh
git clone https://github.com/berkaycagir/hls-restream
cd hls-restream
```

2. Modify `docker-compose.yml` and add your own sources:

```yml
version: "3.4"
services:
  hls:
    build: ./
    container_name: hls
    restart: always
    tmpfs:
      - "/var/www/html:mode=777,size=128M,uid=1000,gid=1000"
    ports:
      - "80:80"
    environment:
      SOURCES: |
        # Full stream
        ch1           rtsp://192.168.1.5:554/ch1
        # Only audio of the stream
        ch1_audio     rtsp://192.168.1.5:554/ch1
        ch1_hd        http://192.168.1.6/stream/channelid/8967896?profile=pass
        ch1_hd_audio  http://192.168.1.6/stream/channelid/8967896?profile=pass
```

Profiles can you find in `profiles/` folder.

* passthrough - default, no transcoding.

3. Start docker compose (run this everytime you modify stream sources):

```sh
docker compose up -d
```

4. Watch streams:

```
http://localhost/ch1.m3u8
http://localhost/ch1_audio.m3u8
http://localhost/ch1_hd_audio.m3u8
http://localhost/ch1_hd_audio.m3u8
```

In case of error, troubleshoot:

```sh
docker compose logs hls
docker compose exec -it hls sh -c 'cd /var/log/supervisor && /bin/bash'
```
