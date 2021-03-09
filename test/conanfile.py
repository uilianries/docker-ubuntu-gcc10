from conans import ConanFile, CMake

class Pkg(ConanFile):
    name = "foobar"
    version = "0.1.0"
    settings = "os", "compiler", "arch", "build_type"
    requires = "fmt/7.1.3"
    exports_sources = "CMakeLists.txt", "main.cpp"
    generators = "cmake", "cmake_find_package"

    def build(self):
        cmake = CMake(self)
        cmake.verbose = True
        cmake.configure()
        cmake.build()
        cmake.test(args=["--verbose"])
