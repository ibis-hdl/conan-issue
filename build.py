import os, shutil, subprocess

def run(cmd):
    os.system(cmd)


try:
    shutil.rmtree("build")
except:
    pass


run("conan version")
run('conan install . --build=missing -s build_type=Release '
    '-c tools.cmake.cmaketoolchain:generator="Ninja Multi-Config"')
run('conan install . --build=missing -s build_type=Debug '
    '-c tools.cmake.cmaketoolchain:generator="Ninja Multi-Config"')
run("cmake --list-presets")
