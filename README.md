# musl-cross-make-nightly
Nightly builds of upstream musl-cross-make toolchain for x86_64 and aarch64.

These are **NOT** my forked version - see below for the rationale behind this
decision. The [musl-cross-make](https://github.com/richfelker/musl-cross-make/)
upstream repository is used for these builds. My fork is put on hiatus for now,
the reason for which is again explained in detail below.

# Obtaining
The [Releases](https://github.com/DanielMYT/musl-cross-make-nightly/releases)
page contains everything you need.

# Build process details
They are built nightly using a GitHub action which runs on Ubuntu (currently
24.04, but this will be bumped to newer versions as time gos on). They are
built natively, so the `x86_64` toolchain is built on an `x86_64` host, and the
`aarch64` toolchain is built on an `aarch64` host.

They are bootstrapped three times for each build - starting from the host
toolchain on Ubuntu. In the following order:

1. Use Ubuntu's host Glibc toolchain to compile first stage musl toolchain.
2. Use first stage musl toolchain to compile second stage musl toolchain.
3. Use second stage musl toolchain to compile final musl toolchain for release.

# Why not the forked version
In the past, I forked **musl-cross-make**. The sole purpose of this fork was to
provide more up-to-date versions of the toolchain components (including GCC and
binutils). At this time upstream was still stuck on heavily outdated versions.

However, as of recently, the upstream project has seen more activity, and the
developer(s) have added support for up-to-date components. As a result, these
can now be used.

I did produce and release builds from my forked version, however this wasn't
ideal, and was not automated. This project aims to fully automate the process,
with nightly releases that run on GitHub actions.

The upstream project code itself has no functionality to "auto-detect" the
newest available supported software version at runtime. As a result, I have
written a script in this repository, called `mcm-latest-hashes.sh`, which, when
either run from the `musl-cross-make` source tree, or has the source directory
passed as an argument, scans each SHA1 checksum file under the `hashes` folder,
and finds the one corresponding to the newest version of each package. It then
produces that output in the formatting expected by `config.mak`. As a result,
this script is automatically used by the build process of these toolchains.
