#!/usr/bin/env bash
# Set the pinned version of one tool this skill upgrades.
set -euo pipefail

usage() { echo "usage: $0 node|yarn|@types/node VERSION" >&2; exit 64; }
[ $# -eq 2 ] || usage
tool=$1 version=$2

root=$(git rev-parse --show-toplevel)
assets="$root/apps/client/assets"

case "$tool" in
  node)
    sed -i '' "s/^nodejs .*/nodejs $version/" "$root/.tool-versions"
    sed -i '' "s/^ARG NODE_VERSION=.*/ARG NODE_VERSION=$version/" "$root/Dockerfile"
    ;;
  yarn)
    (cd "$assets" && mise exec -- corepack yarn set version "$version" --only-if-needed)
    # This repo fetches Yarn through Corepack (#4249), so drop any bundled release.
    rm -rf "$assets/.yarn/releases"
    sed -i '' '/^yarnPath:/d' "$assets/.yarnrc.yml"
    ;;
  @types/node)
    sed -i '' "s|\"@types/node\": *\"[^\"]*\"|\"@types/node\": \"^$version\"|" "$assets/package.json"
    ;;
  *) usage ;;
esac

git -C "$root" diff --stat
