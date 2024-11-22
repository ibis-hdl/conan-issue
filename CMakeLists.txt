cmake_minimum_required(VERSION 3.29.5)      # MS VS limits us

project(conan-issue)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Catch2 3 REQUIRED)

add_subdirectory(source)

include(GNUInstallDirs)

# Unit tests

include(CTest)
enable_testing()
add_subdirectory(testsuite)
