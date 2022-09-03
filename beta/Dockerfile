ARG VERSION="105.0b6"
ARG FIREFOX_LANGUAGE="en-US"

FROM debian:sid-slim as downloader

ARG VERSION
ARG FIREFOX_LANGUAGE

RUN apt-get update \
    && apt-get install -y \
    ca-certificates \
    curl \
    bzip2 \
    xz-utils \
    --no-install-recommends \
    && cd /opt/ \
    && echo "Downloading from https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION}/linux-x86_64/${FIREFOX_LANGUAGE}/firefox-${VERSION}.tar.bz2..." \
    && curl -fSL -o firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION}/linux-x86_64/${FIREFOX_LANGUAGE}/firefox-${VERSION}.tar.bz2" \
    && tar xvjf firefox.tar.bz2 \
    && rm firefox.tar.bz2

FROM debian:sid-slim

ARG VERSION
ARG FIREFOX_LANGUAGE
ENV FIREFOX_VERSION="${VERSION}" \
    LANG="${FIREFOX_LANGUAGE}"

COPY --from=downloader /opt/firefox/ /opt/firefox/

RUN apt-get update \
    && apt-get install -y \
    apulse \
    ca-certificates \
    hicolor-icon-theme \
    libasound2 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxrender1 \
    libx11-xcb-dev \
    libx11-xcb1 \
    libxt6 \
    libxtst6 \
    ffmpeg \
    libpulse0 \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    --no-install-recommends \
    && ln -s /opt/firefox/firefox /usr/local/bin/ \
    && update-alternatives --install /usr/bin/x-www-browser x-www-browser /opt/firefox/firefox 200 \
    && update-alternatives --set x-www-browser /opt/firefox/firefox \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY local.conf /etc/fonts/local.conf

RUN mkdir -p /etc/firefox && \  
    echo 'pref("browser.tabs.remote.autostart", false);' >> /etc/firefox/syspref.js

COPY entrypoint.sh /usr/bin/startfirefox

ENTRYPOINT [ "startfirefox" ]

LABEL org.opencontainers.image.title="Firefox Beta" \
    org.opencontainers.image.description="Firefox Beta in Docker" \
    org.opencontainers.image.version="${VERSION}"

