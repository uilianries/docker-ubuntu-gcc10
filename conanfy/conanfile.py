from conans import ConanFile, tools


class GCCConan(ConanFile):
    settings = "os", "arch"

    def deploy(self):
        self.copy("*", symlinks=True)

    def package(self):
        self.copy("*", src="/tmp/install", symlinks=True)
