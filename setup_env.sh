#!/bin/bash
set -ex
sudo apt-get update -qq
sudo apt-get install -y clang lld bc gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf