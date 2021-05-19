FROM uilianries/base

ARG CONAN_PASSWORD CONAN_LOGIN_USERNAME LLVM_VERSION
ENV CONAN_REVISIONS_ENABLED=1

LABEL maintainer="Conan.io <info@conan.io>"

COPY conanfile.py .

RUN sudo apt-get -qq update \
    && sudo apt-get -q install -y g++-multilib gcc clang-4.0 lld-4.0 libc++abi-dev --no-install-recommends --no-install-suggests \
    && pip install ninja

RUN wget -q --no-check-certificate https://github.com/llvm/llvm-project/archive/llvmorg-${LLVM_VERSION}.tar.gz \
    && tar zxf llvmorg-${LLVM_VERSION}.tar.gz

RUN sed -E -i 's/OUTPUT_NAME\s+"unwind"/OUTPUT_NAME "llvm-unwind"/g' llvm-project-llvmorg-${LLVM_VERSION}/libunwind/src/CMakeLists.txt \
    && grep "llvm-unwind" llvm-project-llvmorg-${LLVM_VERSION}/libunwind/src/CMakeLists.txt \
    && sed -i 's/unwind/llvm-unwind/g' llvm-project-llvmorg-${LLVM_VERSION}/clang/lib/Driver/ToolChains/CommonArgs.cpp \
    && grep "llvm-unwind" llvm-project-llvmorg-${LLVM_VERSION}/clang/lib/Driver/ToolChains/CommonArgs.cpp

RUN cd llvm-project-llvmorg-${LLVM_VERSION} \
    && mkdir build \
    && cd build/ \
    && cmake ../llvm \
       -G Ninja \
       -DCMAKE_CXX_COMPILER=clang++-4.0 \
       -DCMAKE_C_COMPILER=clang-4.0 \
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
       -DLLVM_USE_LINKER=lld-4.0 \
       -DLLVM_OPTIMIZED_TABLEGEN=ON \
       -DLIBUNWIND_ENABLE_ASSERTIONS=OFF \
       -DLIBUNWIND_ENABLE_PEDANTIC=OFF \
       -DLIBUNWIND_ENABLE_SHARED=ON \
       -DLIBUNWIND_ENABLE_STATIC=OFF \
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
       -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=OFF \
       -DLIBCXX_USE_COMPILER_RT=ON \
       -DLIBCXX_DEBUG_BUILD=OFF \
       -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
       -DLIBCXXABI_ENABLE_PEDANTIC=OFF \
       -DLIBCXXABI_BUILD_32_BITS=OFF \
       -DLIBCXXABI_INCLUDE_TESTS=OFF \
       -DLIBCXXABI_ENABLE_SHARED=ON \
       -DLIBCXXABI_ENABLE_STATIC=OFF \
       -DLIBCXXABI_USE_COMPILER_RT=ON \
       -DLIBCXXABI_USE_LLVM_UNWINDER=YES \
       -DLIBCXX_CXX_ABI_INCLUDE_PATHS=/usr/include/libcxxabi \
       -DLIBCXXABI_LIBUNWIND_INCLUDES_INTERNAL=ON \
       -DCOMPILER_RT_INCLUDE_TESTS=OFF \
       -DCOMPILER_RT_USE_LIBCXX=ON \
    && ninja unwind \
    && ninja cxxabi \
    && ninja cxx \
    && ninja clang \
    && ninja lld \
    && ninja compiler-rt \
    && ninja install-unwind install-cxxabi install-cxx install-clang install-lld install-compiler-rt

RUN cp -a llvm-project-llvmorg-${LLVM_VERSION}/build/lib/clang/${LLVM_VERSION}/include /tmp/install/lib/clang/${LLVM_VERSION}/include \
    && cp $(find /home/conan/llvm-project-llvmorg-${LLVM_VERSION}/build/lib -name "*.so*") /tmp/install/lib

RUN conan remote add uilianr https://uilianr.jfrog.io/artifactory/api/conan/local \
    && conan user -r uilianr -p ${CONAN_PASSWORD} ${CONAN_LOGIN_USERNAME} \
    && conan create . clang/${LLVM_VERSION}@uilianries/stable \
    && conan upload --all clang/${LLVM_VERSION}@uilianries/stable -r uilianr \
    && conan user -c
