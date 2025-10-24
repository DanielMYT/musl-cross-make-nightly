#!/usr/bin/env bash
set -e
set +h

# Ensure working directory does not exist.
if test -e work; then
  echo "Error: Remove the existing work directory first." >&2
  exit 1
fi

# Check out source and apply any patches.
mkdir -p work
git clone https://github.com/richfelker/musl-cross-make work/src
if test -d src-apply; then
  while read -r patch; do
    ./try-apply.sh "$patch" work/src
  done < <(find src-apply -mindepth 1 -maxdepth 1 -type f -name \*.patch)
fi

# Set up build config.
cp config.mak.common work/src/config.mak.TEMPLATE
echo "TARGET = $(uname -m)-linux-musl" >> work/src/config.mak.TEMPLATE
./mcm-latest-hashes.sh work/src >> work/src/config.mak.TEMPLATE

# Stage 1 build - using host toolchain and dynamically linked.
cp work/src/config.mak{.TEMPLATE,}
echo "COMMON_CONFIG += CC='gcc' CXX='g++'" >> work/src/config.mak
make -j$(nproc) -C work/src
make -j1 install -C work/src
cp -r work/src/output work/stage1
export PATH_ORIG="$PATH"

# Stage 2 build - using stage 1 toolchain and statically linked.
export PATH="$PWD/work/stage1/bin:$PATH_ORIG"
cp work/src/config.mak{.TEMPLATE,}
echo "COMMON_CONFIG += CC='$(uname -m)-linux-musl-gcc -static --static' CXX='$(uname -m)-linux-musl-g++ -static --static'" >> work/src/config.mak
make -j1 distclean -C work/src
make -j$(nproc) -C work/src
make -j1 install -C work/src
cp -r work/src/output work/stage2

# Stage 3 build - using stage 2 toolchain and statically linked.
export PATH="$PWD/work/stage2/bin:$PATH_ORIG"
make -j1 distclean -C work/src
make -j$(nproc) -C work/src
make -j1 install -C work/src
mkdir -p work/final
cp -r work/src/output work/final/"$(uname -m)"-linux-musl-toolchain

# Finishing up and then cleaning up.
pushd work/final
tar -cvf "$(uname -m)"-linux-musl-toolchain.tar "$(uname -m)"-linux-musl-toolchain
xz -v9e "$(uname -m)"-linux-musl-toolchain.tar
popd
mv work/final/"$(uname -m)"-linux-musl-toolchain.tar.xz .
rm -rf work
sync
