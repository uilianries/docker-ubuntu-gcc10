ARG DOCKER_REPOSITORY CONAN_VERSION

FROM ${DOCKER_REPOSITORY}/base-ubuntu16.04:${CONAN_VERSION} as builder

ARG LLVM_VERSION ARTIFACTORY_REPOSITORY LIBSTDCPP_VERSION

LABEL maintainer="Conan.io <info@conan.io>"

RUN sudo apt-get -qq update \
    && sudo apt-get -qq install -y --no-install-recommends --no-install-suggests -o=Dpkg::Use-Pty=0 apt-transport-https \
    && printf 'deb http://apt.llvm.org/xenial/   llvm-toolchain-xenial-10  main\n' | sudo tee /etc/apt/sources.list.d/llvm.list \
    && wget -q --no-check-certificate https://apt.llvm.org/llvm-snapshot.gpg.key \
    && sudo apt-key add llvm-snapshot.gpg.key \
    && sudo apt-get -qq update \
    && sudo apt-get -qq install -y --no-install-recommends --no-install-suggests -o=Dpkg::Use-Pty=0 clang-10 lld-10 libc++-10-dev \
    && pip install ninja \
    && wget -q --no-check-certificate https://github.com/llvm/llvm-project/archive/llvmorg-${LLVM_VERSION}.tar.gz \
    && tar zxf llvmorg-${LLVM_VERSION}.tar.gz \
    && sed -E -i 's/OUTPUT_NAME\s+"unwind"/OUTPUT_NAME "llvm-unwind"/g' llvm-project-llvmorg-${LLVM_VERSION}/libunwind/src/CMakeLists.txt \
    && sed -i 's/unwind/llvm-unwind/g' llvm-project-llvmorg-${LLVM_VERSION}/clang/lib/Driver/ToolChains/CommonArgs.cpp \
    && cd llvm-project-llvmorg-${LLVM_VERSION} \
    && mkdir build \
    && cd build/ \
    && cmake ../llvm \
       -G Ninja \
       -DCMAKE_CXX_COMPILER=clang++-10 \
       -DCMAKE_C_COMPILER=clang-10 \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
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
       -DLLVM_ENABLE_PROJECTS="libunwind;clang;libcxx;libcxxabi;lld;compiler-rt" \
       -DLLVM_BUILD_DOCS=OFF \
       -DLLVM_BUILD_TESTS=OFF \
       -DLLVM_BUILD_32_BITS=OFF \
       -DLLVM_BUILD_TOOLS=OFF \
       -DLLVM_BUILD_UTILS=OFF \
       -DLLVM_BUILD_EXAMPLES=OFF \
       -DLLVM_BUILD_BENCHMARKS=OFF \
       -DLLVM_BUILD_STATIC=OFF \
       -DLLVM_USE_SANITIZER=OFF \
       -DLLVM_USE_LINKER=lld-10 \
       -DLLVM_OPTIMIZED_TABLEGEN=ON \
       -DLIBUNWIND_ENABLE_ASSERTIONS=OFF \
       -DLIBUNWIND_ENABLE_PEDANTIC=OFF \
       -DLIBUNWIND_ENABLE_SHARED=ON \
       -DLIBUNWIND_ENABLE_STATIC=ON \
       -DLIBUNWIND_USE_COMPILER_RT=ON \
       -DCLANG_INCLUDE_TESTS=OFF \
       -DCLANG_ENABLE_ARCMT=OFF \
       -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
       -DCLANG_INCLUDE_DOCS=OFF \
       -DCLANG_BUILD_EXAMPLES=OFF \
       -DCLANG_ENABLE_BOOTSTRAP=OFF \
       -DCLANG_DEFAULT_RTLIB=compiler-rt \
       -DCLANG_DEFAULT_UNWINDLIB=libunwind \
       -DLIBCXX_INCLUDE_TESTS=OFF \
       -DLIBCXX_ENABLE_SHARED=YES \
       -DLIBCXX_ENABLE_STATIC=OFF \
       -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
       -DLIBCXX_INCLUDE_DOCS=OFF \
       -DLIBCXX_GENERATE_COVERAGE=OFF \
       -DLIBCXX_BUILD_32_BITS=OFF \
       -DLIBCXX_CXX_ABI=libcxxabi \
       -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
       -DLIBCXX_USE_COMPILER_RT=ON \
       -DLIBCXX_DEBUG_BUILD=OFF \
       -DLIBCXX_CXX_ABI=libcxxabi \
       -DLIBCXX_CXX_ABI_INCLUDE_PATHS=../libcxxabi/include/ \
       -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
       -DLIBCXXABI_ENABLE_PEDANTIC=OFF \
       -DLIBCXXABI_BUILD_32_BITS=OFF \
       -DLIBCXXABI_INCLUDE_TESTS=OFF \
       -DLIBCXXABI_ENABLE_SHARED=ON \
       -DLIBCXXABI_ENABLE_STATIC=ON \
       -DLIBCXXABI_USE_COMPILER_RT=ON \
       -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
       -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
       -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=ON \
       -DLIBCXXABI_LIBUNWIND_INCLUDES_INTERNAL=ON \
       -DCOMPILER_RT_INCLUDE_TESTS=OFF \
       -DCOMPILER_RT_USE_LIBCXX=ON \
    && ninja unwind \
    && ninja cxxabi \
    && sudo cp lib/libc++abi* /usr/lib/ \
    && ninja cxx \
    && ninja clang \
    && ninja lld \
    && ninja compiler-rt \
    && ninja install-unwind install-cxxabi install-cxx install-clang install-lld install-compiler-rt \
    && cp -a lib/clang/${LLVM_VERSION}/include /tmp/install/lib/clang/${LLVM_VERSION}/include \
    && cp $(find lib -name "*.so*") /tmp/install/lib \
    && mkdir /tmp/gcc \
    && curl -s -O "${ARTIFACTORY_REPOSITORY}/gcc-${LIBSTDCPP_VERSION}.tar.gz" \
    && tar zxf gcc-${LIBSTDCPP_VERSION}.tar.gz -C /tmp/gcc

# FIXME: Clang 9 and 10 fail to build libcxx because they try to link libc++abi from system.
#        We could add a patch with target_link_directories, but I prefered copying libc++abi to /usr/lib

FROM ${DOCKER_REPOSITORY}/base as deploy

ARG CONAN_VERSION LIBSTDCPP_VERSION

COPY --from=builder /tmp/install /tmp/clang
COPY --from=builder /tmp/gcc /tmp/gcc

RUN sudo mv /tmp/gcc/lib64 /usr/local/ \
    && sudo ln -s -f /usr/local/lib64/libstdc++.so.6.0.28 /usr/local/lib64/libstdc++.so.6 \
    && sudo ln -s -f /usr/local/lib64/libstdc++.so.6 /usr/local/lib64/libstdc++.so \
    && sudo cp -a /tmp/gcc/include/* /usr/local/include/ \
    && sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/* \
    && sudo cp -a /tmp/gcc/lib/gcc/x86_64-linux-gnu/${LIBSTDCPP_VERSION} /usr/lib/gcc/x86_64-linux-gnu/ \
    && sudo cp -a /tmp/gcc/lib/* /usr/local/lib/ \
    && sudo rm -rf /tmp/gcc \
    && sudo cp -a /tmp/clang/bin/* /usr/local/bin/ \
    && sudo cp -a /tmp/clang/lib/* /usr/local/lib/ \
    && sudo cp -a /tmp/clang/include/* /usr/local/include/ \
    && sudo rm -rf /tmp/clang \
    && sudo update-alternatives --install /usr/local/bin/cc cc /usr/local/bin/clang 100 \
    && sudo update-alternatives --install /usr/local/bin/cpp ccp /usr/local/bin/clang++ 100 \
    && sudo update-alternatives --install /usr/local/bin/c++ c++ /usr/local/bin/clang++ 100 \
    && sudo update-alternatives --install /usr/local/bin/ld ld /usr/local/bin/ld.lld 100 \
    && sudo rm /etc/ld.so.cache \
    && sudo ldconfig -C /etc/ld.so.cache \
    && pip install conan==${CONAN_VERSION}
