FROM uilianries/base

LABEL maintainer="Conan.io <info@conan.io>"

USER root

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-8.4.0/gcc-8.4.0.tar.xz \
    && tar Jxf gcc-8.4.0.tar.xz \
    && cd gcc-8.4.0 \
    && ./configure --build=x86_64-linux-gnu --disable-bootstrap --disable-multilib --disable-nsl --enable-languages=c,c++,fortran --without-isl --with-system-zlib --prefix=/tmp/install \
    && make -j2 \
    && make install-strip \
    && rm -rf gcc-8.4.0.tar.xz gcc-8.4.0

RUN apt-get purge -y g++-multilib \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/*

RUN mv /tmp/install/bin/* /usr/local/bin \
    && mv /usr/local/libexec/gcc/x86_64-linux-gnu/8.4.0/* /usr/local/libexec \
    && mv /usr/local/include/include/c++/8.4.0/* /usr/local/include \
    && update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/gcc 100

USER conan
