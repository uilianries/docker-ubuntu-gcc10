### How does it work?

There are 2 Docker images and 3 stages (base, builder, final).

## Base

First, we build repository/base (based on Xenial), which is a complete docker image,
with conan, cmake, apt packages, python, jfrog cli, and most important
libstdc++.so.0.6.28. That library is created by GCC10, so we build gcc,
and copy only lib64 folder to /usr/local

### Builder

It's part of the second Docker image.
Here we are using the [multi stage](https://docs.docker.com/develop/develop-images/multistage-build/) support.

It builds a gcc/clang version and install all artifacts at /tmp/install.

The compiler used to build gcc from sources is the native gcc5.

#### GCC (final)

It's part of the second Docker image.
Here we are using the [multi stage](https://docs.docker.com/develop/develop-images/multistage-build/) support.

As final step, we copy compiler artifacts from Builder stage to Base docker image.

The final image contains 2 libstdc++ versions:
- /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21: The original version from Ubuntu Xenial
- /usr/local/lib64/libstdc++.so.6.0.28: The latest version provided by gcc10

To handle such order correctly, ldconfig is executed, and the prioty order becomes
/usr/local/lib instead of /usr/lib, so the latest version should be used by
default.

The glibc version keeps the from system: Ubuntu GLIBC 2.23-0ubuntu11.2

#### Clang (final)

It's part of the second Docker image.
Here we are using the [multi stage](https://docs.docker.com/develop/develop-images/multistage-build/) support.

Unlike GCC, Clang takes +1h to be built, thus, be patient.

We re-use same Base image for Clang. We dropped Clang versions 4,5,6,7 and 8 due thier age
and complexity when building. We would need to pass configuration file, patch LLVM source
code and create a wrapper script to manage the configuration on runtime. Too fragile.

The Builder step is more complex here, Clang offers tons of arguments and may vary
according the version.

The Clang compiler generated is ligcc_s free, instead, we are using llvm libunwind
and llvm compiler-rt. As libunwind has more providers, we renamed the library to
libllvm-unwind, it avoids name collision when running Conan with libunwind as
requirement.

The compiler used to build clang from sources is the llvm (apt) Clang 10.
Ubuntu Xenial offers Clang 4.0, but it's uncapable to build Clang 12.

#### Legacy problems

As all libraries are built as shared and the default runtime library is compiler-rt,
the libllvm-unwind must be listed to be linked to every build, otherwise, Clang will
fail.

Since Clang 9, the build argument CLANG_DEFAULT_UNWINDLIB allows us running Clang with
llvm-unwind linked by default, no extra steps are required. However, older versions
require that unwind be listed during Clang execution to avoid errors.

Since Clang 6.0, LLVM added configuration file support, where we pass extra arguments
to the compiler when running, including libraries such llvm-unwind. However, it does
not load automatically, the user still need to pass --config <path> to the compiler.
Thus, to avoid this complexity, we needed a wrapper script, which invokes clang --config

Since Clang 7, Clang loads the configuration file automatically, if the compiler name
follows the configuration file name too. Thus, we added a prefix to Clang: x86_64-clang,
so clang will load /usr/local/bin/x86_64.cfg automatically.

Clang 8 changes the default include folders path. If we don't move the libstdc++ headers,
it creates a mess when building.

More info about configuration files [here](https://clang.llvm.org/docs/UsersManual.html#configuration-files).

### Testing

To validate all those Docker images, we run some tests:

#### Simple hello world

Under test/simple is a simple hello world in C and C++. It's simple, but important,
we can valid libunwind missing, or any other system library missing.

#### Eating our Dog Food

Using Conan, we build Zlib, Fmt, Spdlog and Unwind from sources and link to example apps.
So, we run a vanilla Ubuntu Xenial container, copy those apps to there, plus libc++,
libstdc++ and libstdc++11 from new compiler images.

#### Fortran (GCC only)

As GCC has fortran support enabled, we need validate all libraries are there.
We build a hello world app with Fortran and CMake

#### Large Conan packages

Poco is a large package which requires more headers than usual.
This test is too validate if we forgot some header or library

#### C++ Standard support

Validate the standard library support, we build 2 different packages:

- imagl/0.2.1: Requires C++20
- libsolace/0.3.9: Requires C++17 and is not header-only

### How to Build

First, you will installed:

- Docker
- Docker Compose (pip install docker-compose)

Second, you have to set the DOCKER_REPOSITORY name:

    export DOCKER_REPOSITORY=${USER}

Or, if you are on Windows:

    set DOCKER_REPOSITORY=%USERNAME%

So finally you can build any image:

    docker-compose build gcc10
    docker-compose build clang11

### LICENSE

[MIT](LICENSE)
