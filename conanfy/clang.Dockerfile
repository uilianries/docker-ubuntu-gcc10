FROM uilianries/base

ARG CONAN_PASSWORD ARG CONAN_LOGIN_USERNAME ARG LLVM_VERSION
ENV CONAN_REVISIONS_ENABLED=1

LABEL maintainer="Conan.io <info@conan.io>"

COPY conanfile.py .

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && conan user -r uilianr -p ${CONAN_PASSWORD} ${CONAN_LOGIN_USERNAME}

RUN wget -q --no-check-certificate https://github.com/llvm/llvm-project/archive/llvmorg-${LLVM_VERSION}.tar.gz \
    && tar zxf llvmorg-${LLVM_VERSION}.tar.gz

RUN cd llvm-project-llvmorg-${LLVM_VERSION} \
    && mkdir build \
    && cd build/ \
    && cmake ../llvm \
       -DCMAKE_BUILD_TYPE=Release \
       -DBUILD_SHARED_LIBS=ON \
       -DCMAKE_INSTALL_PREFIX=/tmp/install \
       -DLLVM_INCLUDE_EXAMPLES=OFF \
       -DLLVM_INCLUDE_TESTS=OFF \
       -DLLVM_INCLUDE_GO_TESTS=OFF \
       -DLLVM_INCLUDE_DOCS=OFF \
       -DLLVM_INCLUDE_TOOLS=ON \
       -DLLVM_INCLUDE_UTILS=OFF \
       -DLLVM_INCLUDE_BENCHMARKS=OFF \
       -DLLVM_TARGETS_TO_BUILD=X86 \
       -DLLVM_ENABLE_OCAMLDOC=OFF \
       -DLLVM_ENABLE_BACKTRACES=OFF \
       -DLLVM_ENABLE_WARNINGS=OFF \
       -DLLVM_ENABLE_PEDANTIC=OFF \
       -DLLVM_ENABLE_ASSERTIONS=OFF \
       -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" \
       -DLLVM_BUILD_DOCS=OFF \
       -DLLVM_BUILD_TESTS=OFF \
       -DLLVM_BUILD_32_BITS=OFF \
       -DLLVM_BUILD_TOOLS=OFF \
       -DLLVM_BUILD_UTILS=OFF \
       -DLLVM_BUILD_EXAMPLES=OFF \
       -DLLVM_BUILD_BENCHMARKS=OFF \
       -DLLVM_BUILD_STATIC=OFF \
       -DLLVM_USE_SANITIZER=OFF \
       -DLLVM_OPTIMIZED_TABLEGEN=ON \
       -DCLANG_INCLUDE_TESTS=OFF \
       -DCLANG_ENABLE_ARCMT=OFF \
       -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
       -DCLANG_INCLUDE_DOCS=OFF \
       -DCLANG_BUILD_EXAMPLES=OFF \
       -DCLANG_ENABLE_BOOTSTRAP=OFF \
       -DLIBCXX_INCLUDE_TESTS=OFF \
       -DLIBCXX_ENABLE_SHARED=YES \
       -DLIBCXX_ENABLE_STATIC=OFF \
       -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
       -DLIBCXX_INCLUDE_DOCS=OFF \
       -DLIBCXX_GENERATE_COVERAGE=OFF \
       -DLIBCXX_BUILD_32_BITS=OFF \
       -DLIBCXX_DEBUG_BUILD=OFF \
       -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
       -DLIBCXXABI_ENABLE_PEDANTIC=OFF \
       -DLIBCXXABI_BUILD_32_BITS=OFF \
       -DLIBCXXABI_INCLUDE_TESTS=OFF \
       -DLIBCXXABI_ENABLE_SHARED=ON \
       -DLIBCXXABI_ENABLE_STATIC=OFF \


    && cmake --build . --target cxxabi \
    && cmake --build . --target cxx \
    && cmake --build . --target clang --parallel \
    && cmake --build . --target install-cxxabi install-cxx install-clang

RUN conan create . clang/${LLVM_VERSION}@uilianries/stable \
    && conan upload --all clang/${LLVM_VERSION}@uilianries/stable -r uilianr
