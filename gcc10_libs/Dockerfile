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

RUN mv /tmp/install/lib /usr/local \
    && mv /tmp/install/lib64 /usr/local \
    && printf '/usr/local/lib\n' > /etc/ld.so.conf.d/20local-lib.conf \
    && printf '/usr/local/lib64\n' >> /etc/ld.so.conf.d/20local-lib.conf \
    && ln -s -f /usr/local/lib64/libstdc++.so.6.0.28 /usr/local/lib64/libstdc++.so.6 \
    && mv /etc/ld.so.conf.d/libc.conf /etc/ld.so.conf.d/10libc.conf \
    && mv /etc/ld.so.conf.d/x86_64-linux-gnu.conf /etc/ld.so.conf.d/30x86_64-linux-gnu.conf \
    && mv /etc/ld.so.conf.d/zz_i386-biarch-compat.conf /etc/ld.so.conf.d/40zz_i386-biarch-compat.conf \
    && mv /etc/ld.so.conf.d/zz_x32-biarch-compat.conf /etc/ld.so.conf.d/50zz_x32-biarch-compat.conf \
    && rm /etc/ld.so.cache \
    && ldconfig
