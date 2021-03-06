FROM ubuntu:xenial

LABEL maintainer="Conan.io <info@conan.io>"

WORKDIR /root

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
       sudo \
       binutils \
       wget \
       git \
       g++-multilib \
       libgmp-dev \
       libmpfr-dev \
       libmpc-dev \
       nasm \
       dh-autoreconf \
       libffi-dev \
       libssl-dev \
       pkg-config \
       subversion \
       zlib1g-dev \
       libbz2-dev \
       libsqlite3-dev \
       libreadline-dev \
       xz-utils \
       curl \
       libncurses5-dev \
       libncursesw5-dev \
       liblzma-dev \
       ca-certificates \
       autoconf-archive \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-10.2.0/gcc-10.2.0.tar.xz \
    && tar Jxf gcc-10.2.0.tar.xz \
    && cd gcc-10.2.0 \
    && ./configure --build=x86_64-linux-gnu --disable-bootstrap --disable-multilib --disable-nsl --enable-languages=c,c++,fortran \
    && make -j2 \
    && printf '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf \
    && ldconfig -v \
    && make install-strip \
    && apt-get purge -y g++-multilib gcc gcc-5 \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/gcc 100 \
    && rm -rf /root/gcc-10.2.0.tar.xz /root/gcc-10.2.0
