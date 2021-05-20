FROM uilianries/base

LABEL maintainer="Conan.io <info@conan.io>"

ARG LLVM_VERSION LLVM_MAJOR GCC_VERSION=10.3.0

ENV CC=clang \
    CXX=clang++ \
    CMAKE_C_COMPILER=clang \
    CMAKE_CXX_COMPILER=clang++

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && mkdir /tmp/install \
    && cd /tmp/install \
    && conan install clang/${LLVM_VERSION}@uilianries/stable -r uilianr -g deploy

USER root

RUN mv /tmp/install/bin/* /usr/local/bin \
    && mv /tmp/install/lib/* /usr/local/lib \
    && cp -a /tmp/install/include/* /usr/local/include

COPY clang clang++ /usr/local/bin/

RUN ln -rs /usr/local/bin/clang-${LLVM_MAJOR} /usr/local/bin/x86_64-clang \
    && ln -rs /usr/local/bin/clang-${LLVM_MAJOR} /usr/local/bin/x86_64-clang++ \
    && printf -- "-lllvm-unwind\n" > /usr/local/bin/x86_64.cfg \
    && update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/clang 100 \
    && update-alternatives --install /usr/local/bin/cpp ccp /usr/local/bin/clang++ 100 \
    && update-alternatives --install /usr/local/bin/ld ld /usr/local/bin/ld.lld 100

RUN mv /usr/local/include/c++/${GCC_VERSION}/* /usr/local/include \
    && mv /usr/local/include/x86_64-linux-gnu/bits/* /usr/local/include/bits/ \
    && mv /usr/local/include/x86_64-linux-gnu/ext/* /usr/local/include/ext/ \
    && rm -rf /usr/local/include/${GCC_VERSION}

RUN rm -rf /tmp/install \
    && rm -rf /home/conan/.conan \
    && rm /etc/ld.so.cache \
    && ldconfig -C /etc/ld.so.cache

USER conan
