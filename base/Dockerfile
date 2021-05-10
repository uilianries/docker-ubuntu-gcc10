FROM ubuntu:xenial

LABEL maintainer="Conan.io <info@conan.io>"

ENV PYENV_ROOT=/opt/pyenv \
    PATH=/opt/pyenv/shims:${PATH}

ARG GCC_VERSION

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

RUN wget -q --no-check-certificate http://mirrors.concertpass.com/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz \
    && tar Jxf gcc-${GCC_VERSION}.tar.xz \
    && cd gcc-${GCC_VERSION} \
    && ./configure --build=x86_64-linux-gnu --disable-bootstrap --disable-multilib --disable-nsl --enable-languages=c,c++,fortran --without-isl --with-system-zlib --prefix=/tmp/base \
    && make -j2 \
    && make install-strip \
    && rm -rf /root/gcc-${GCC_VERSION}.tar.xz /root/gcc-${GCC_VERSION}

RUN wget -q --no-check-certificate https://cmake.org/files/v3.19/cmake-3.19.6-Linux-x86_64.tar.gz \
    && tar -xzf cmake-3.19.6-Linux-x86_64.tar.gz \
       --exclude=bin/cmake-gui \
       --exclude=doc/cmake \
       --exclude=share/cmake-3.19/Help \
       --exclude=share/vim \
       --exclude=share/vim \
    && cp -fR cmake-3.19.6-Linux-x86_64/* /usr \
    && rm -rf /root/cmake-3.19.6-Linux-x86_64 \
    && rm /root/cmake-3.19.6-Linux-x86_64.tar.gz

RUN wget -q --no-check-certificate -O /usr/local/bin/jfrog https://api.bintray.com/content/jfrog/jfrog-cli-go/\$latest/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 \
    && chmod +x /usr/local/bin/jfrog

RUN groupadd 1001 -g 1001 \
    && groupadd 1000 -g 1000 \
    && groupadd 2000 -g 2000 \
    && groupadd 999 -g 999 \
    && useradd -ms /bin/bash conan -g 1001 -G 1000,2000,999 \
    && printf "conan:conan" | chpasswd \
    && adduser conan sudo \
    && printf "conan ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

RUN wget --no-check-certificate --quiet -O /tmp/pyenv-installer https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer \
    && chmod +x /tmp/pyenv-installer \
    && /tmp/pyenv-installer \
    && rm /tmp/pyenv-installer \
    && update-alternatives --install /usr/bin/pyenv pyenv /opt/pyenv/bin/pyenv 100 \
    && PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.8 \
    && pyenv global 3.8.8

# remove all __pycache__ directories created by pyenv
RUN chown -R conan:1001 /opt/pyenv \
    && find /opt/pyenv -iname __pycache__ -print0 | xargs -0 rm -rf \
    && update-alternatives --install /usr/bin/python3 python3 /opt/pyenv/shims/python3 100 \
    && update-alternatives --install /usr/bin/pip3 pip3 /opt/pyenv/shims/pip3 100 \
    && update-alternatives --install /usr/local/bin/python python /opt/pyenv/shims/python 100 \
    && update-alternatives --install /usr/local/bin/pip pip /opt/pyenv/shims/pip 100

RUN pip install -q --upgrade --no-cache-dir pip \
    pip install -q --no-cache-dir conan conan-package-tools

RUN mv /tmp/base/lib64 /usr/local \
    && rm /usr/local/include/*.h \
    && printf '/usr/local/lib\n' > /etc/ld.so.conf.d/20local-lib.conf \
    && printf '/usr/local/lib64\n' >> /etc/ld.so.conf.d/20local-lib.conf \
    && ln -s -f /usr/local/lib64/libstdc++.so.6.0.28 /usr/local/lib64/libstdc++.so.6 \
    && mv /etc/ld.so.conf.d/libc.conf /etc/ld.so.conf.d/10libc.conf \
    && mv /etc/ld.so.conf.d/x86_64-linux-gnu.conf /etc/ld.so.conf.d/30x86_64-linux-gnu.conf \
    && mv /etc/ld.so.conf.d/zz_i386-biarch-compat.conf /etc/ld.so.conf.d/40zz_i386-biarch-compat.conf \
    && mv /etc/ld.so.conf.d/zz_x32-biarch-compat.conf /etc/ld.so.conf.d/50zz_x32-biarch-compat.conf \
    && rm /etc/ld.so.cache \
    && ldconfig -C /etc/ld.so.cache

USER conan
WORKDIR /home/conan

RUN mkdir -p /home/conan/.conan \
    && printf 'eval "$(pyenv init -)"\n' >> ~/.bashrc \
    && printf 'eval "$(pyenv virtualenv-init -)"\n' >> ~/.bashrc
