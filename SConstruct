#!/usr/bin/env python
import subprocess
import os
from pathlib import Path

ADDON_DIR = "project/addons/libm8gd"
BUILD_DIR = "build"
TARGET_LIB = "libm8gd"

env = SConscript("thirdparty/godot-cpp/SConstruct")


def call(*args) -> str:
    return subprocess.run(args, capture_output=True).stdout.decode().strip()


def call_split(*args) -> list[str]:
    return call(*args).split(" ")


# create build directory if doesn't exist
Path(BUILD_DIR).mkdir(exist_ok=True)

USING_OSXCROSS: bool = "OSXCROSS_ROOT" in os.environ

if USING_OSXCROSS:
    if env["arch"] == "universal":
        print("OSXCross does not support universal builds.")
        Exit(255)
    else:
        print("using OSXCross SDK: %s" % env["osxcross_sdk"])


# LIBSERIALPORT flags

LIBSP_TARGET = "serialport"

libsp_env = env.Clone(
    CFLAGS="-std=c99 -Wall -pedantic -Wmissing-prototypes -Wshadow -DSP_PRIV=",
)
LIBSP_SOURCES = [
    "thirdparty/libserialport/serialport.c",
    "thirdparty/libserialport/timing.c",
    "thirdparty/libserialport/libserialport_internal.h",
]

match env["platform"]:
    case "linux":
        LIBSP_SOURCES.append(
            [
                "thirdparty/libserialport/linux.c",
                "thirdparty/libserialport/linux_termios.c",
                "thirdparty/libserialport/linux_termios.h",
            ]
        )
    case "windows":
        LIBSP_SOURCES.append(["thirdparty/libserialport/windows.c"])
        libsp_env["CFLAGS"] += " -DLIBSERIALPORT_MSBUILD"
        # libsp_env["CFLAGS"] += " -mwindows"
    case "macos":
        LIBSP_SOURCES.append(["thirdparty/libserialport/macosx.c"])
    case platform:
        raise BuildError("unknown platform: %s" % platform)

libsp = libsp_env.StaticLibrary(target=LIBSP_TARGET, source=LIBSP_SOURCES)


print("using cxx: %s" % env["CXX"])
print("architecture: %s" % env["arch"])

# add sources
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

# set flags
if env["target"] == "template_release":
    env.Append(CFLAGS=["-O2"])

env.Append(CFLAGS=["-Wall", "-pipe"])
env.Append(CFLAGS=["-Ithirdparty/libserialport"])
env.Append(LIBS=[libsp])

# create library target
match env["platform"]:
    case "macos":
        library = env.SharedLibrary(
            target="%s/%s.%s.%s.framework"
            % (ADDON_DIR, TARGET_LIB, env["platform"], env["target"]),
            source=sources,
        )
    case "windows":
        env.Append(LIBS=["setupapi"])  # used by libserialport on windows
        library = env.SharedLibrary(
            target="%s/%s.%s.%s%s"
            % (
                ADDON_DIR,
                TARGET_LIB,
                env["platform"],
                env["target"],
                env["SHLIBSUFFIX"],
            ),
            source=sources,
        )
    case "linux":
        library = env.SharedLibrary(
            target="%s/%s.%s.%s%s"
            % (
                ADDON_DIR,
                TARGET_LIB,
                env["platform"],
                env["target"],
                env["SHLIBSUFFIX"],
            ),
            source=sources,
        )

Default(library)
