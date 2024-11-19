from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, cmake_layout
import json

class CompressorRecipe(ConanFile):
    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"

    def requirements(self):
        self.requires("catch2/3.7.1")

    def layout(self):
        # see: conan.io #17324
        #self.folders.build_folder_vars = ["settings.compiler", "settings.build_type"]
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)
        tc.user_presets_path = "ConanCMakePresets.json"
        tc.generate()
        # see: conan-io #16036, we'll use our own calculation
        # https://pynative.com/python-json-load-and-loads-to-parse-json/
        #presets = json.loads(json.load("ConanCMakePresets.json"))
        #del presets["jobs"]
        #json.save(self, "ConanCMakePresets.json", json.dumps(presets, indent=4))
