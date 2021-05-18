FROM uilianries/base

LABEL maintainer="Conan.io <info@conan.io>"

ARG LLVM_VERSION LLVM_MAJOR

ENV CONAN_REVISIONS_ENABLED=1 \
    CC=x86_64-clang \
    CXX=x86_64-clang++ \
    CMAKE_C_COMPILER=x86_64-clang \
    CMAKE_CXX_COMPILER=x86_64-clang++

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && mkdir /tmp/install \
    && cd /tmp/install \
    && conan install clang/${LLVM_VERSION}@uilianries/stable -g deploy

USER root

RUN apt-get purge -y g++-multilib gcc \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get -qq update \
    && rm -rf /var/lib/apt/lists/*

RUN mv /tmp/install/bin/* /usr/local/bin \
    && mv /tmp/install/lib/* /usr/local/lib \
    && cp -a /tmp/install/include/* /usr/local/include

RUN ln -rs /usr/local/bin/clang-${LLVM_MAJOR} /usr/local/bin/x86_64-clang \
    && ln -rs /usr/local/bin/clang-${LLVM_MAJOR} /usr/local/bin/x86_64-clang++ \
    && printf -- "-lunwind\n" > /usr/local/bin/x86_64.cfg \
    && update-alternatives --install /usr/bin/cc cc /usr/local/bin/x86_64-clang 100 \
    && update-alternatives --install /usr/bin/cpp ccp /usr/local/bin/x86_64-clang++ 100 \
    && update-alternatives --install /usr/bin/ld ld /usr/local/bin/ld.lld 100

RUN rm -rf /tmp/install \
    && rm -rf /home/conan/.conan \
    && rm /etc/ld.so.cache \
    && ldconfig -C /etc/ld.so.cache


USER conan
