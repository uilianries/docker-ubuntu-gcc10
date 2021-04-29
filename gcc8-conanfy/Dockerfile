FROM uilianries/base

ARG CONAN_PASSWORD
ARG CONAN_LOGIN_USERNAME
ENV CONAN_LOGIN_USERNAME ${CONAN_LOGIN_USERNAME}
ENV CONAN_PASSWORD ${CONAN_PASSWORD}

LABEL maintainer="Conan.io <info@conan.io>"

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/virtual \
    && conan user -r uilianr -p ${CONAN_PASSWORD} ${CONAN_LOGIN_USERNAME}

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-8.4.0/gcc-8.4.0.tar.xz \
    && tar Jxf gcc-8.4.0.tar.xz \
    && cd gcc-8.4.0 \
    && ./configure --build=x86_64-linux-gnu --disable-bootstrap --disable-multilib --disable-nsl --enable-languages=c,c++,fortran --without-isl --with-system-zlib --prefix=/tmp/install \
    && make -j2 \
    && make install-strip \
    && rm -rf gcc-8.4.0.tar.xz gcc-8.4.0

RUN conan create . gcc/8.4.0@uilianries/stable \
    && conan upload --all gcc/8.4.0@uilianries/stable -r uilianr
