#
# rfctools Docker File
# Copyright (C) 2018-2026
# Paul E. Jones <paulej@packetizer.com>
#

FROM fedora:43
LABEL org.opencontainers.image.authors="paulej@packetizer.com"
LABEL org.opencontainers.image.description="Docker image that houses RFC tools for creating Internet Drafts from mmark markdown documents"
LABEL org.opencontainers.image.source="https://github.com/paulej/rfctools"
LABEL org.opencontainers.image.licenses="MIT"

# Install binaries from Fedora needed for xml2rfc
RUN dnf -y update --refresh && \
    dnf -y install curl unzip python3 python3-pip python3-lxml python3-wheel \
        python3-cairo cairo cairo-devel pango gdk-pixbuf2 \
        weasyprint findutils make golang-github-mmarkdown-mmark && \
    dnf clean all

# Install some packages via pip
RUN pip install 'xml2rfc' 'xml2rfc[pdf]' 'weasyprint>=53.0'

# Creating the default cache directory
RUN rm -fr /root/.cache && \
    mkdir -p /var/cache/xml2rfc && \
    chmod 777 /var/cache/xml2rfc

# Get Noto and Roboto fonts files (per the xml2rfc instructions)
RUN curl curl -v -L 'https://github.com/ietf-tools/xml2rfc-fonts/archive/refs/tags/3.22.0.tar.gz' >/tmp/fonts.tgz && \
    tar -xzf /tmp/fonts.tgz --strip-components=1 -C /usr/share/fonts/ \
        xml2rfc-fonts-3.22.0/noto xml2rfc-fonts-3.22.0/roboto_mono && \
    rm -f /tmp/fonts.tgz && \
    fc-cache -f -v

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Specify the working directory when a container is started
WORKDIR /rfc
