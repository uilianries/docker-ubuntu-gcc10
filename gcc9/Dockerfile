FROM uilianries/base

LABEL maintainer="Conan.io <info@conan.io>"

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-9.3.0/gcc-9.3.0.tar.xz \
    && tar Jxf gcc-9.3.0.tar.xz \
    && cd gcc-9.3.0 \
    && ./configure --build=x86_64-linux-gnu --disable-bootstrap --disable-multilib --disable-nsl --enable-languages=c,c++,fortran --without-isl --with-system-zlib \
    && make -j2 \
    && printf '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf \
    && ldconfig -v \
    && make install-strip \
    && update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/gcc 100 \
    && rm -rf /root/gcc-9.3.0.tar.xz /root/gcc-9.3.0


RUN apt-get purge -y g++-multilib \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get update

#USER conan
#WORKDIR /home/conan