FROM uilianries/base

LABEL maintainer="Conan.io <info@conan.io>"

ENV CONAN_REVISIONS_ENABLED=1

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && mkdir /tmp/install \
    && cd /tmp/install \
    && conan install gcc/9.3.0@uilianries/stable -g deploy

USER root

RUN apt-get purge -y g++-multilib \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/*

RUN mv /tmp/install/bin/* /usr/local/bin \
    && mv /tmp/install/libexec /usr/local/libexec \
    && mv /tmp/install/include/c++/9.3.0/* /usr/local/include \
    && update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/gcc 100 \
    && rm -rf /tmp/install \
    && rm -rf /home/conan/.conan

USER conan
