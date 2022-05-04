FROM debian:bullseye-20220418-slim

RUN apt-get update -y \
    && apt-get install -y \
    build-essential \
    chrpath \
    cpio \
    debianutils \
    device-tree-compiler \
    diffstat \
    file \
    gawk \
    gcc \
    git \
    iproute2 \
    iptables \
    iputils-ping \
    iputils-ping \
    kmod \
    libegl1-mesa \
    liblz4-tool \
    libsdl1.2-dev \
    locales \
    make \
    mesa-common-dev \
    pylint3 \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    socat \
    sudo \
    texinfo \
    unzip \
    vim \
    wget \
    xterm \
    xz-utils \
    zstd

COPY overlay/. .

WORKDIR /opt/yocto
ENV YOCTO_CODENAME dunfell

# bitbake does not run in root so create an unprivileged user
RUN useradd builder \
    && mkdir -p /opt/yocto/build \
    && chown builder:builder -R /opt \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8 \
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime \
    && usermod -aG sudo builder \
    && echo "builder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/builder

USER builder

ENTRYPOINT [ "/entrypoint.sh" ]