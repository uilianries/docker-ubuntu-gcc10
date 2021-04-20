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

#RUN apt-get purge -y g++-multilib \
#    && apt-get autoremove -y \
#    && apt-get autoclean \
#    && apt-get update

#USER conan
#WORKDIR /home/conan
WORKDIR /root

RUN printf "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu trusty main\n" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F \
    && apt-get update

RUN cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21 /tmp/libstdc++.so.6.0.21 \
    && apt-get install --no-install-recommends --no-install-suggests -y \
       libstdc++-5-dev \
       libstdc++-6-dev \
       libstdc++-7-dev \
       libstdc++-8-dev \
       libstdc++-9-dev

RUN cp /tmp/libstdc++.so.6.0.21 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21 \
    && ln -s /usr/lib/gcc/x86_64-linux-gnu/9/libstdc++.so /usr/lib/gcc/x86_64-linux-gnu/9/libstdc++.so.9 \
    && ln -s /usr/lib/gcc/x86_64-linux-gnu/8/libstdc++.so /usr/lib/gcc/x86_64-linux-gnu/8/libstdc++.so.8 \
    && ln -s /usr/lib/gcc/x86_64-linux-gnu/7/libstdc++.so /usr/lib/gcc/x86_64-linux-gnu/7/libstdc++.so.7 \
    && ln -s /usr/lib/gcc/x86_64-linux-gnu/6/libstdc++.so /usr/lib/gcc/x86_64-linux-gnu/6/libstdc++.so.6 \
    && ln -s /usr/lib/gcc/x86_64-linux-gnu/5/libstdc++.so /usr/lib/gcc/x86_64-linux-gnu/5/libstdc++.so.5 \
    && printf /usr/lib/gcc/x86_64-linux-gnu/9/ >> /etc/ld.so.conf.d/libstdcpp-dev.conf \
    && printf /usr/lib/gcc/x86_64-linux-gnu/8/ >> /etc/ld.so.conf.d/libstdcpp-dev.conf \
    && printf /usr/lib/gcc/x86_64-linux-gnu/7/ >> /etc/ld.so.conf.d/libstdcpp-dev.conf \
    && printf /usr/lib/gcc/x86_64-linux-gnu/6/ >> /etc/ld.so.conf.d/libstdcpp-dev.conf \
    && printf /usr/lib/gcc/x86_64-linux-gnu/5/ >> /etc/ld.so.conf.d/libstdcpp-dev.conf \
    && ldconfig \
    && ln -s -f /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21 /usr/lib/x86_64-linux-gnu/libstdc++.so.6

RUN mkdir -p /home/conan/.conan \
    && printf 'eval "$(pyenv init -)"\n' >> ~/.bashrc \
    && printf 'eval "$(pyenv virtualenv-init -)"\n' >> ~/.bashrc