# conan-issue
Repository to handle with cmake and conan

Prerequisite:
- Ubuntu 24.04
```
$ cat ~/.conan2/profiles/clang
[settings]
arch=x86_64
build_type=Release
compiler=clang
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version=18
os=Linux

[buildenv]
CC=clang
CXX=clang++

[conf]
tools.build:compiler_executables={ "c": "/usr/bin/clang", "cpp": "/usr/bin/clang++" }
```

Changes in `conanfile.py`
```python
    def layout(self):
        # see: conan.io #17324
        self.folders.build_folder_vars = ["settings.compiler", "settings.build_type"]

```
Changes in `CMakePresets.json` (concrete `cmake/common.json`)
```
    "configurePresets": [
        ...
        {
            "name": "ninja-default-settings",
            "description": "Common settings related to build tool Ninja.",
            "hidden": true,
            "binaryDir": "${sourceDir}/build/${buildPresets}",
            ...
        },
```

try to build:
```
$ ./conan_install.py --profile clang
conan install . --settings build_type=Release --conf tools.cmake.cmaketoolchain:generator='Ninja Multi-Config' --build=missing --output-folder=. --profile:all=clang
...
conan install . --settings build_type=Release --conf tools.cmake.cmaketoolchain:generator='Ninja Multi-Config' --build=missing --output-folder=. --profile:all=clang
...
...
$ cmake --list-presets
CMake Error: Could not read presets from /workspaces/conan-issue:
Invalid preset: "clang"
```
which results to:
```
$ cat build/clang-debug/generators/CMakePresets.json
...
    "configurePresets": [
        {
            "name": "conan-clang-debug",
            ...
        }
    ],
    "buildPresets": [
        {
            "name": "conan-clang-debug",
            "configurePreset": "conan-clang-debug",
            "configuration": "Debug"
        }
    ],
    ...
```
but in `CMakePresets.json` there are (e.g. for gcc, msvc)
```
    "configurePresets": [
        {
            "name": "gcc",
            ...
            "inherits": [
                ...
                "conan-default",
                ...
            ]
        },
        ...
        {
            "name": "msvc",
            "inherits": [
                ...
                "conan-default",
                ...
            ]
        },
```
where the inherited `"conan-default"` (or even other settings) aren't here - how to cope with it?
The error message below is misleading and results only from missing inheritance name
```
$ cmake --list-presets
CMake Error: Could not read presets from /workspaces/conan-issue:
Invalid preset: "clang"
```
and how to write it now for `"conan-clang-debug"` and `"conan-clang-release"`?

The same problem rises with Ninja's single target I mentioned at [#17324](https://github.com/conan-io/conan/issues/17324).
