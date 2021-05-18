FROM uilianries/base

ARG CONAN_PASSWORD CONAN_LOGIN_USERNAME GCC_VERSION
ENV CONAN_REVISIONS_ENABLED=1

LABEL maintainer="Conan.io <info@conan.io>"

COPY conanfile.py .

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

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && conan user -r uilianr -p ${CONAN_PASSWORD} ${CONAN_LOGIN_USERNAME} \
    && conan create . gcc/${GCC_VERSION}@uilianries/stable \
    && conan upload --all gcc/${GCC_VERSION}@uilianries/stable -r uilianr \
    && conan user -c
