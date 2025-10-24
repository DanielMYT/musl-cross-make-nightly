#!/usr/bin/bash
set -e

# Apply a patch using 'patch --dry-run' first.
# Then only fully apply it if 'patch --dry-run' succeeds.
# Ignore it (and don't exit with error) if unable to apply.

PATCH="$1"
APPLY="$2"

if test -z "$1" || test -z "$2"; then
  echo "Usage: $(basename "$0") <patch-file> <apply-directory>" >&2
  exit 1
fi

if test ! -r "$PATCH"; then
  echo "Error: Could not access patch file '$PATCH'." >&2
  exit 1
fi

if test ! -d "$APPLY"; then
  echo "Error: Could not access apply directory '$APPLY'." >&2
  exit 1
fi

REALPATCH="$(readlink -f "$PATCH")"
REALAPPLY="$(readlink -f "$APPLY")"

pushd "$REALAPPLY" >/dev/null

if patch --dry-run -fNp1 -i "$REALPATCH" &>/dev/null; then
  echo "'$REALPATCH' is valid. Applying to '$REALAPPLY'..."
  patch -fNp1 -i "$REALPATCH"
  echo "Successfully applied '$REALPATCH' to '$REALAPPLY'."
else
  echo "Warning: '$REALPATCH' cannot be applied to '$REALAPPLY'." >&2
fi

popd >/dev/null
