This directory can contain any patches to apply to the upstream source tree
after checkout. For example, if a newer piece of software is not currently
supported by upstream.

Any file with the '.patch' extension will be attempted to apply to the source
tree. Any errors will be warned about but not treated as fatal, so as to avoid
an error caused by (e.g.,) an already-applied patch.

In particular it was inspired by the following as-yet-ignored-by-upstream pull
requests:

* https://github.com/richfelker/musl-cross-make/pull/213
* https://github.com/richfelker/musl-cross-make/pull/214
* https://github.com/richfelker/musl-cross-make/pull/216

It's worth nothing that we should not add any new software version willy-nilly.
Otherwise the mistakes of my old musl-cross-make fork will be repeated. We must
instead make sure only to add ones which are both well-tested, and which have
had the patches updated for them (e.g., gcc-15.1.0 patches brought forward to
gcc-15.2.0).
