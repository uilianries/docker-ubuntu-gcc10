FROM uilianries/base

ARG CONAN_PASSWORD ARG CONAN_LOGIN_USERNAME ARG LLVM_VERSION
ENV CONAN_REVISIONS_ENABLED=1

LABEL maintainer="Conan.io <info@conan.io>"

COPY conanfile.py .

RUN sudo apt-get -qq update \
    && sudo apt-get -q install -y clang-4.0 --no-install-recommends --no-install-suggests \
    && sudo rm -rf /var/lib/apt/lists/*

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && conan user -r uilianr -p ${CONAN_PASSWORD} ${CONAN_LOGIN_USERNAME}

RUN wget -q --no-check-certificate https://github.com/llvm/llvm-project/archive/llvmorg-${LLVM_VERSION}.tar.gz \
    && tar zxf llvmorg-${LLVM_VERSION}.tar.gz

RUN cd llvm-project-llvmorg-${LLVM_VERSION} \
    && mkdir build \
    && cd build/ \
    && cmake ../llvm \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_INSTALL_PREFIX=/tmp/install \
       -DLLVM_ENABLE_PROJECTS=clang \
       -DLLVM_INCLUDE_EXAMPLES=OFF \
       -DLLVM_INCLUDE_TESTS=OFF \
       -DLLVM_INCLUDE_GO_TESTS=OFF \
       -DLLVM_INCLUDE_DOCS=OFF \
       -DBUILD_SHARED_LIBS=ON \
       -DLLVM_TARGETS_TO_BUILD=HOST \
       -DLLVM_ENABLE_OCAMLDOC=OFF \
       -DLLVM_BUILD_DOCS=OFF \
       -DLLVM_OPTIMIZED_TABLEGEN=ON \
       -DCLANG_INCLUDE_TESTS=OFF \
       -DLIBCXX_INCLUDE_TESTS=OFF \
       -DLIBCXX_ENABLE_SHARED=YES \
       -DLIBCXX_ENABLE_STATIC=NO \
       -DCLANG_BUILD_EXAMPLES=OFF \
       -DLLVM_BUILD_TOOLS=OFF \
       -DCMAKE_C_COMPILER=clang-4.0 \
       -DCMAKE_CXX_COMPILER=clang++-4.0 \
       -DLLVM_ENABLE_PROJECTS="libcxx;libcxxabi" \
       -DLLVM_BUILD_32_BITS=OFF \
    && make -s \
    && make install-cxx install-cxxabi

RUN conan create . clang/${LLVM_VERSION}@uilianries/stable \
    && conan upload --all clang/${LLVM_VERSION}@uilianries/stable -r uilianr
