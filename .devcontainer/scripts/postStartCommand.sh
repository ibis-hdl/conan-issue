#!/usr/bin/env bash

set -ex

install_conan() {
    # cope with python3's pip error: externally-managed-environment on creating venv
    pipx install conan
}

# helper to adjust concrete compiler to be used
conan_buildenv_conf()
{
    local CC=$1
    local CXX=$2
    cat << EOF

[buildenv]
CC=$CC
CXX=$CXX

[conf]
tools.build:compiler_executables={ "c": "$(which $CC)", "cpp": "$(which $CXX)" }
EOF
}

configure_conan_profile() {
    # create default compiler preset for Conan2
    local conan_profile=default
    conan profile detect --force --name ${conan_profile}

    # create GCC compiler preset for Conan2
    local conan_profile=gcc
    CXX=g++ conan profile detect --force --name ${conan_profile}
    cat << EOF  >> ~/.conan2/profiles/${conan_profile}
$(conan_buildenv_conf 'gcc' 'g++')
EOF
    cat ~/.conan2/profiles/${conan_profile}

    # create Clang compiler preset for Conan2
    local conan_profile=clang
    CXX=clang++ conan profile detect --force --name ${conan_profile}
    cat << EOF  >> ~/.conan2/profiles/${conan_profile}
$(conan_buildenv_conf 'clang' 'clang++')
EOF
    cat ~/.conan2/profiles/${conan_profile}

    # create Clang-libc++ compiler preset for Conan2
    local conan_profile=clang-libc++
    CXX=clang++ conan profile detect --force --name ${conan_profile}
    sed -i ~/.conan2/profiles/${conan_profile} -E \
        -e "s|^(compiler\.libcxx\s*)=(.*)$|\1=libc++|g"
    cat << EOF  >> ~/.conan2/profiles/${conan_profile}
$(conan_buildenv_conf 'clang' 'clang++')
EOF
    cat ~/.conan2/profiles/${conan_profile}
}

configure_conan_profile
