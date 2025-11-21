# Mailmaster for Linux using Selkies baseimage
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# Metadata labels
LABEL org.opencontainers.image.title="Mailmaster Selkies"
LABEL org.opencontainers.image.description="Mailmaster Linux client in browser via Selkies WebRTC"
LABEL org.opencontainers.image.vendor="Mailmaster Selkies Project"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"

# set environment variables
RUN apt-get update && \
    apt-get install -y wget libdbus-glib-1-2 libnss-wrapper \
    fonts-noto-cjk libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
    libxcb-render-util0 libxcb-xkb1 libxkbcommon-x11-0 \
    shared-mime-info desktop-file-utils libxcb1 libxcb-icccm4 libxcb-image0 \
    libxcb-keysyms1 libxcb-randr0 libxcb-render0 libxcb-render-util0 libxcb-shape0 \
    libxcb-shm0 libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xkb1 libxcb-xinerama0 \
    libxcb-xkb1 libxcb-glx0 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libfontconfig1 libgbm1 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
    libxss1 libxtst6 libatomic1 libxcomposite1 libxrender1 libxrandr2 libxkbcommon-x11-0 \
    libfontconfig1 libdbus-1-3 libnss3 libx11-xcb1 python3-tk stalonetray

RUN pip install --no-cache-dir python-xlib

RUN wget http://kr.archive.ubuntu.com/ubuntu/pool/universe/g/gconf/libgconf-2-4_3.2.6-6ubuntu1_amd64.deb && \
    wget http://kr.archive.ubuntu.com/ubuntu/pool/universe/g/gconf/gconf2-common_3.2.6-6ubuntu1_all.deb  && \
    dpkg -i gconf2-common_3.2.6-6ubuntu1_all.deb && \
    dpkg -i libgconf-2-4_3.2.6-6ubuntu1_amd64.deb

# Install Mailmaster based on target architecture
RUN Mailmaster_URL="https://res.126.net/dl/client/linuxmail/dashi/mail.deb" && \
    wget -O mail.deb "$Mailmaster_URL" && \
    echo "Installing Mailmaster..." && \
    (dpkg -i mail.deb || (apt-get update && apt-get install -f -y && dpkg -i mail.deb)) && \
    rm -f mail.deb && \
    echo "Mailmaster installation completed for Mailmaster"

# Clean up
RUN apt-get purge -y --autoremove
RUN apt-get autoclean && \
    rm -rf \
        /config/.cache \
        /config/.npm \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

# configure openbox dock mode for stalonetray
RUN sed -i '/<dock>/,/<\/dock>/s/<noStrut>no<\/noStrut>/<noStrut>yes<\/noStrut>/' /etc/xdg/openbox/rc.xml

# set app name
ENV TITLE="Mailmaster-Selkies"
ENV TZ="Asia/Shanghai"
ENV LC_ALL="zh_CN.UTF-8"
ENV AUTO_START_Mailmaster="true"

# update favicon
RUN cp /opt/mailmaster/logo.ico /usr/share/selkies/www/icon.ico

# add local files
COPY /root /
