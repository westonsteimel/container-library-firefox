FROM alpine:latest

RUN apk add --no-cache \
	alsa-lib \
    ca-certificates \
	firefox \
    ttf-dejavu

RUN addgroup firefox \
    && adduser -G firefox -s /bin/sh -D firefox \
    && chown -R firefox:firefox /home/firefox \
    && addgroup firefox audio \
    && addgroup firefox video

USER firefox

ENTRYPOINT ["/usr/bin/firefox"]
