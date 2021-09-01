#
# rfctools Docker File
# Copyright (C) 2018-2021
# Paul E. Jones <paulej@packetizer.com>
#

FROM fedora:34
LABEL org.opencontainers.image.authors="paulej@packetizer.com"
LABEL org.opencontainers.image.description="Docker image that houses RFC tools for creating Internet Drafts from mmark markdown documents"
LABEL org.opencontainers.image.source="https://github.com/paulej/rfctools"
LABEL org.opencontainers.image.licenses="MIT"

# Install binaries from Fedora needed for golang, python, xml2rfc, and mmark
RUN dnf -y install python python-lxml golang golang-github-burntsushi-toml \
        golang-github-burntsushi-toml-devel git && \
    dnf clean all

# Update pip and install xml2rfc, creating the default cache directory
RUN pip install --upgrade pip && \
    pip install xml2rfc && \
    mkdir -p /var/cache/xml2rfc

# Clone the mmark repository and build the mmark binary
ENV GOPATH /usr/share/gocode
RUN git clone --depth=1 --branch=master https://github.com/mmarkdown/mmark.git \
        /usr/share/gocode/src/github.com/mmarkdown/mmark && \
    rm -fr /usr/share/gocode/src/github.com/mmarkdown/mmark/.git && \
    cd /usr/share/gocode/src/github.com/mmarkdown/mmark/ && \
    go get && go build && \
    ln -s /usr/share/gocode/src/github.com/mmarkdown/mmark/mmark /usr/bin/mmark

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Specify the working directory when a container is started
WORKDIR /rfc
