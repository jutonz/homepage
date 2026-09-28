#!/usr/bin/env bash
# Install, lint, typecheck, and build the frontend under the pinned Node and Yarn.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)/apps/client/assets"

# mise exec runs the pinned Node even when the old shim still wins on PATH, and
# corepack resolves the packageManager-pinned Yarn under it. Plain `yarn` here
# runs a shim built for whichever Node PATH points at, which may be the old one.
yarn() { mise exec -- corepack yarn "$@"; }

step() { echo; echo "=== $* ==="; }

step node version
mise exec -- node --version

step yarn version
yarn --version

step yarn install
yarn install

step yarn install --immutable
yarn install --immutable

step yarn lint --check
yarn lint --check

step yarn typecheck
yarn typecheck

step yarn bundle:css
yarn bundle:css

# bundle:js watches and never exits unless MIX_ENV is prod, which takes the
# one-shot build() path and prints bundle sizes plus a Done line.
step yarn bundle:js
MIX_ENV=prod yarn bundle:js

echo
echo "All asset checks passed."
