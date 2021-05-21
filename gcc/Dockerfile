ARG DOCKER_REPOSITORY

FROM ${DOCKER_REPOSITORY}/base as builder

ARG GCC_VERSION

LABEL maintainer="Conan.io <info@conan.io>"

RUN sudo apt-get -qq update \
    && sudo apt-get -q install -y g++-multilib gcc --no-install-recommends --no-install-suggests

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz \
    && tar Jxf gcc-${GCC_VERSION}.tar.xz \
    && cd gcc-${GCC_VERSION} \
    && ./configure --build=x86_64-linux-gnu \
                   --disable-bootstrap \
                   --disable-multilib \
                   --disable-nsl \
                   --enable-languages=c,c++,fortran \
                   --disable-werror \
                   --without-isl \
                   --enable-gold \
                   --with-system-zlib \
                   --prefix=/tmp/install \
    && make -j$(nproc) \
    && make install-strip

FROM ${DOCKER_REPOSITORY}/base as final

ARG GCC_VERSION

COPY --from=builder /tmp/install /tmp/install

RUN sudo mv /tmp/install/bin/* /usr/local/bin \
    && sudo rm -rf /usr/local/lib/gcc \
    && sudo mv /tmp/install/lib/* /usr/local/lib \
    && sudo mv /tmp/install/libexec /usr/local/libexec \
    && sudo mv /tmp/install/include/c++/${GCC_VERSION}/* /usr/local/include/ \
    && sudo update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/gcc 100 \
    && sudo update-alternatives --install /usr/local/bin/cpp cpp /usr/local/bin/g++ 100 \
    && sudo update-alternatives --install /usr/local/bin/c++ c++ /usr/local/bin/g++ 100 \
    && sudo rm -rf /tmp/install \
    && sudo rm /etc/ld.so.cache \
    && sudo ldconfig -C /etc/ld.so.cache