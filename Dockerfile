#
# rfctools Docker File
# Copyright (C) 2018-2022
# Paul E. Jones <paulej@packetizer.com>
#

# Build an intermediate container for mmark
FROM fedora:35 as mmark_builder
RUN dnf -y update --refresh && \
    dnf -y install golang golang-github-burntsushi-toml \
        golang-github-burntsushi-toml-devel git && \
    dnf clean all

# Clone the mmark repository and build the mmark binary
ENV GOPATH /usr/share/gocode
RUN git clone --branch=v2.2.25 https://github.com/mmarkdown/mmark.git \
        /usr/share/gocode/src/github.com/mmarkdown/mmark && \
    cd /usr/share/gocode/src/github.com/mmarkdown/mmark/ && \
    go get && go build

# Build the rfctools container
FROM fedora:35
LABEL org.opencontainers.image.authors="paulej@packetizer.com"
LABEL org.opencontainers.image.description="Docker image that houses RFC tools for creating Internet Drafts from mmark markdown documents"
LABEL org.opencontainers.image.source="https://github.com/paulej/rfctools"
LABEL org.opencontainers.image.licenses="MIT"

# Install binaries from Fedora needed for xml2rfc
RUN dnf -y update --refresh && \
    dnf -y install curl unzip python3 python3-pip python3-lxml python3-wheel \
        python3-cairo cairo pango gdk-pixbuf2 findutils make && \
    dnf clean all

# Copy the mmark binary to the /usr/bin directory
COPY --from=mmark_builder \
    /usr/share/gocode/src/github.com/mmarkdown/mmark/mmark /usr/bin/mmark

# Update pip and install xml2rfc, creating the default cache directory
RUN pip install --upgrade pip && \
    pip install xml2rfc && \
    pip install 'weasyprint<=0.42.3' && \
    rm -fr /root/.cache && \
    mkdir -p /var/cache/xml2rfc && \
    chmod 777 /var/cache/xml2rfc

# Get Noto and Roboto fonts files (per the xml2rfc instructions)
RUN curl https://noto-website-2.storage.googleapis.com/pkgs/Noto-unhinted.zip \
         >/tmp/noto.zip && \
    mkdir -p /usr/share/fonts/noto && \
    unzip -d /usr/share/fonts/noto /tmp/noto.zip && \
    rm -f /tmp/noto.zip && \
    chmod o+r /usr/share/fonts/noto/* && \
    curl https://fonts.google.com/download?family=Roboto%20Mono \
        >/tmp/roboto.zip && \
    mkdir -p /usr/share/fonts/roboto && \
    unzip -d /usr/share/fonts/roboto /tmp/roboto.zip && \
    rm -f /tmp/roboto.zip && \
    find /usr/share/fonts/roboto -exec chmod o+r {} \; && \
    fc-cache -f -v

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Specify the working directory when a container is started
WORKDIR /rfc
