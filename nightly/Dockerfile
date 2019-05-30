FROM westonsteimel/alpine-glibc:edge as downloader

RUN apk add --no-cache \
    ca-certificates \
    curl \
    bzip2 \
    xz \
    tar \
    && cd /opt/ \
    && curl -fSL -o firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US" \
    && tar xvjf firefox.tar.bz2 \
    && rm firefox.tar.bz2

FROM westonsteimel/alpine-glibc:edge

COPY --from=downloader /opt/firefox/ /opt/firefox/

RUN apk upgrade && apk add --no-cache \
    alsa-lib \
    pulseaudio-alsa \
    dbus-x11 \
    dbus-glib \
    ca-certificates \
    gtk+3.0 \
    libxt \
    ffmpeg \
    hicolor-icon-theme \
    mesa-dri-intel \
    mesa-gl \
    ttf-dejavu

# Add firefox user
RUN addgroup firefox \
    && adduser -G firefox -s /bin/sh -D firefox \
    && chown -R firefox:firefox /home/firefox \
    && addgroup firefox audio \
    && addgroup firefox video

# Run Firefox as non privileged user
#USER firefox

ENTRYPOINT ["/opt/firefox/firefox"]
