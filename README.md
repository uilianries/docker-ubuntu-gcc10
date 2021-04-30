#### How does it work?

There are 3 images, but only 1 matters.

First, we build uilianries/base (based on Xenial), which is a complete docker image,
with conan, cmake, apt packages, python, jfrog cli, and most important
libstdc++.so.0.6.28. That library is created by GCC10, so we build gcc,
and copy only lib64 folder to /usr/local

Second, we create conanfy images (based on Base). It's binary packaging of
any compiler version, we build a gcc version and package all artifacts into
a conan package. The conan is uploaded to uilianr.jfrog.io. The compiler used
to build gcc from sources is the native gcc5.

As final step, we clue Base docker image with compiler artifacts from Conan,
remove the native gcc5 from system and copy all compiler header and libraries
to /usr/local.

The final image contains 2 libstdc++ versions:
- /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21: The original version from Ubuntu Xenial
- /usr/local/lib64/libstdc++.so.6.0.28: The latest version provided by gcc10

To handle such order correctly, ldconfig is executed, and the prioty order becomes
/usr/local/lib instead of /usr/lib, so the latest version should be used by
default.

The glibc version keeps the from system.

#### Testing

To validate all, we build Zlib and Spdlog from sources and link to example apps.
So, we run a vanilla Ubuntu Xenial container, copy those apps, the newer
libstdc++ and execute them.
