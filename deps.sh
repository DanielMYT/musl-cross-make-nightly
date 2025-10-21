#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install build-essential bison curl file flex git m4 pkg-config rsync xz-utils
