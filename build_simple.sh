#!/bin/bash

# Exit on error
set -e

# Forcefully remove the .config file from the source tree.
# This file's presence triggers a "not clean" error during an
# out-of-tree build.
rm -f .config

# The build system seems to have KBUILD_OUTPUT=out set by default.
# Unset it to ensure we can clean the source tree properly.
unset KBUILD_OUTPUT

# Clean the source tree first.
make mrproper

# Setup build environment
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Jules"
export KBUILD_BUILD_HOST="Android"
export TZ=":Asia/Kolkata"
export PATH="/builder/toolchains/clang/bin:/builder/toolchains/gcc-arm/bin:/builder/toolchains/gcc-arm64/bin:${PATH}"
export AR=llvm-ar

# Now, perform the out-of-tree build.
# Configure the kernel
make O=out raphael_docker_defconfig

# Update the configuration with default values for new options
# to avoid interactive prompts.
make O=out olddefconfig

# Build the kernel
make O=out -j$(nproc --all) \
    CC=clang \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- \
    KBUILD_CFLAGS+="-Wno-error=vla" \
    KBUILD_ASFLAGS+="-Wno-error=vla"