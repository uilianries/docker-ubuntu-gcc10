ARG DOCKER_REPOSITORY

FROM ${DOCKER_REPOSITORY}/base as builder

ARG GCC_VERSION ARTIFACTORY_TOKEN ARTIFACTORY_REPOSITORY

LABEL maintainer="Conan.io <info@conan.io>"

RUN sudo apt-get -qq update \
    && sudo apt-get -qq install -y --no-install-recommends --no-install-suggests -o=Dpkg::Use-Pty=0 g++-multilib gcc

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz \
    && tar Jxf gcc-${GCC_VERSION}.tar.xz

RUN cd gcc-${GCC_VERSION} \
    && ./configure --build=x86_64-linux-gnu \
                   --disable-bootstrap \
                   --disable-multilib \
                   --disable-nsl \
                   --enable-languages=c,c++,fortran \
                   --disable-werror \
                   --without-isl \
                   --with-system-zlib \
                   --prefix=/tmp/install \
    && make -s -j$(nproc) \
    && make install-strip

RUN tar zcf gcc-${GCC_VERSION}.tar.gz -C /tmp/install . \
    && curl -s -H "X-JFrog-Art-Api:${ARTIFACTORY_TOKEN}" -T gcc-${GCC_VERSION}.tar.gz "${ARTIFACTORY_REPOSITORY}/gcc-${GCC_VERSION}.tar.gz"

RUN mkdir /tmp/gcc \
    && curl -s -O "${ARTIFACTORY_REPOSITORY}/gcc-10.3.0.tar.gz" \
    && tar zxf gcc-10.3.0.tar.gz -C /tmp/gcc

FROM ${DOCKER_REPOSITORY}/base as final

ARG GCC_VERSION ARTIFACTORY_REPOSITORY

COPY --from=builder /tmp/install /usr/local
COPY --from=builder /tmp/gcc /tmp/gcc

USER root

RUN mv /tmp/gcc/lib64/libstdc++.so.6.0.28 /usr/local/lib64/libstdc++.so.6.0.28 \
    && ln -s -f /usr/local/lib64/libstdc++.so.6.0.28 /usr/local/lib64/libstdc++.so.6 \
    && rm -rf /tmp/gcc

RUN update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/gcc 100 \
    && update-alternatives --install /usr/local/bin/cpp cpp /usr/local/bin/g++ 100 \
    && update-alternatives --install /usr/local/bin/c++ c++ /usr/local/bin/g++ 100 \
    && rm /etc/ld.so.cache \
    && ldconfig -C /etc/ld.so.cache

USER conan