### How does it work?

There are 3 images (base, conanfy, final), but only 1 matters.

### Base

First, we build uilianries/base (based on Xenial), which is a complete docker image,
with conan, cmake, apt packages, python, jfrog cli, and most important
libstdc++.so.0.6.28. That library is created by GCC10, so we build gcc,
and copy only lib64 folder to /usr/local

### Conanfy

Second, we create Conan compiler packages. It builds a gcc/clang version and package
all artifacts into a conan package. The package is uploaded to uilianr.jfrog.io.

#### GCC

The compiler used to build gcc from sources is the native gcc5.

As final step, we copy compiler artifacts from Conan to Base docker image and
copy all compiler header and libraries to /usr/local.

The final image contains 2 libstdc++ versions:
- /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21: The original version from Ubuntu Xenial
- /usr/local/lib64/libstdc++.so.6.0.28: The latest version provided by gcc10

To handle such order correctly, ldconfig is executed, and the prioty order becomes
/usr/local/lib instead of /usr/lib, so the latest version should be used by
default.

The glibc version keeps the from system: Ubuntu GLIBC 2.23-0ubuntu11.2

#### Clang

Unlike GCC, Clang takes +1h to be built, so it's being added in parts.

We re-use same Base image for Clang. We dropped Clang 4 and 5 due thier age
and complexity when building.

The Conanfy step is more complex, Clang offers tons of arguments and may vary
according the version.

The Clang compiler generated is ligcc_s free, instead, we are using llvm libunwind
and llvm compiler-rt. As libunwind has more providers, we renamed the library to
libllvm-unwind, it avoids name collision when running Conan with libunwind as
requirement.

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
Thus, to avoid this complexity, we added a script wrapper, which invokes clang --config

Since Clang 7, Clang loads the configuration file automatically, if the compiler name
follows the configuration file name too. Thus, we added a prefix to Clang: x86_64-clang,
so clang will load /usr/local/bin/x86_64.cfg automatically.

More info about configuration files [here](https://clang.llvm.org/docs/UsersManual.html#configuration-files).

### Testing

To validate all those Docker images, we run 2 main tests:

#### Simple hello world

Under test/simple is a simple hello world in C and C++. It's simple, but important,
we can valid libunwind missing, or any other system library missing.

#### Eating our Dog Food

Using Conan, we build Zlib, Fmt, Spdlog and Unwind from sources and link to example apps.
So, we run a vanilla Ubuntu Xenial container, copy those apps to there, plus libc++ and
libstdc++ from new compiler images.

### LICENSE

[MIT](LICENSE)
