# conan-issue
Repository to handle with cmake and conan

Using [cmake-conan](https://github.com/conan-io/cmake-conan), according
conan.io [#16171](https://github.com/conan-io/conan/issues/16171).

With default build path all went fine, but by change of `conanfile.py`:

```
    def layout(self):
        # see: conan.io #17324
        self.folders.build_folder_vars = ["settings.compiler", "settings.build_type"]
        cmake_layout(self)
```

it doesn't build anymore:

```
$ cmake --list-presets
Available configure presets:

  "gcc"          - GnuC
  "clang"        - Clang
  "clang-libc++" - Clang-libc++
$ cmake --build --preset clang-release
[1/8 (0.089s)] Scanning /workspaces/conan-issue/testsuite/test_me.cpp for CXX dependencies
FAILED: testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o.ddi
"/usr/bin/clang-scan-deps-18" -format=p1689 -- /usr/bin/clang++ -DCMAKE_INTDIR=\"Release\" -I/workspaces/conan-issue/src -O3 -DNDEBUG -std=c++20 -x c++ /workspaces/conan-issue/testsuite/test_me.cpp -c -o testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o -resource-dir "/usr/lib/llvm-18/lib/clang/18" -MT testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o.ddi -MD -MF testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o.ddi.d > testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o.ddi.tmp && mv testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o.ddi.tmp testsuite/CMakeFiles/conan-issue_unit_tests.dir/Release/test_me.cpp.o.ddi
Error while scanning dependencies for /workspaces/conan-issue/testsuite/test_me.cpp:
/workspaces/conan-issue/testsuite/test_me.cpp:1:10: fatal error: 'catch2/catch_test_macros.hpp' file not found
[2/8 (0.167s)] Scanning /workspaces/conan-issue/source/main.cpp for CXX dependencies
ninja: build stopped: subcommand failed.
```
