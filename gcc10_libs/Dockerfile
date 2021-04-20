FROM ubuntu:xenial

LABEL maintainer="Conan.io <info@conan.io>"

ENV PYENV_ROOT=/opt/pyenv \
    PATH=/opt/pyenv/shims:${PATH}

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
    && rm -rf /var/lib/apt/lists/*

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-10.2.0/gcc-10.2.0.tar.xz \
    && tar Jxf gcc-10.2.0.tar.xz \
    && cd gcc-10.2.0 \
    && ./configure --build=x86_64-linux-gnu --disable-bootstrap --disable-multilib --disable-nsl --enable-languages=c,c++,fortran --without-isl --with-system-zlib --prefix=/tmp/install \
    && make -j2 \
    && make install-strip
