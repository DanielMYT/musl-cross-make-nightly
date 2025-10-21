#!/usr/bin/env bash
set -e

# Get the latest known package versions from musl-cross-make source tree.
# This is based on SHA1 checksum files stored in the 'hashes/' directory.

if test ! -d hashes; then
  if test -z "$1"; then
    echo "Usage: $(basename "$0") <musl-cross-make-source-dir>" >&2
    exit 1
  elif test ! -d "$1"/hashes; then
    echo "Error: '$1' is not the musl-cross-make source directory." >&2
    exit 1
  fi
  work="$1"
else
  work="$PWD"
fi

cd "$work"

for pkg in binutils gcc gmp isl linux mpc mpfr musl; do
  pvar="$(echo "$pkg" | tr '[:lower:]' '[:upper:]')_VER"
  pver="$(find hashes -mindepth 1 -maxdepth 1 -type f -name "$pkg"-\*.\*.tar.\*.sha1 ! -name linux-headers-\* | sort -Vr | head -n1 | sed "s|^hashes/$pkg-||" | sed 's|.tar.*.sha1$||')"
  echo "$pvar = $pver"
done
