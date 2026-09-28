#!/usr/bin/env bash
# Report the pinned and latest version of every tool this skill upgrades.
set -euo pipefail

root=$(git rev-parse --show-toplevel)
pkg="$root/apps/client/assets/package.json"

node_pin=$(awk '/^nodejs /{print $2}' "$root/.tool-versions")
docker_pin=$(awk -F= '/^ARG NODE_VERSION=/{print $2}' "$root/Dockerfile")
yarn_pin=$(sed -n 's/.*"packageManager": *"yarn@\([^"]*\)".*/\1/p' "$pkg")
types_pin=$(sed -n 's/.*"@types\/node": *"[^0-9]*\([^"]*\)".*/\1/p' "$pkg")

# The lts field is a codename string on an LTS release and false otherwise.
node_latest=$(curl -s https://nodejs.org/dist/index.json \
  | python3 -c "import json,sys;print(next(x for x in json.load(sys.stdin) if x['lts'])['version'].lstrip('v'))")
# The yarn npm package is frozen Yarn 1.x. Modern Yarn ships as @yarnpkg/cli-dist.
yarn_latest=$(curl -s https://registry.npmjs.org/@yarnpkg/cli-dist \
  | python3 -c "import json,sys;print(json.load(sys.stdin)['dist-tags']['latest'])")
# @types/node mirrors the Node major, so the latest tag can describe a runtime we do not run.
types_latest=$(curl -s https://registry.npmjs.org/@types/node \
  | python3 -c "
import json,sys
major='${node_latest%%.*}.'
vs=[v for v in json.load(sys.stdin)['versions'] if v.startswith(major) and '-' not in v]
print(sorted(vs,key=lambda s:[int(n) for n in s.split('.')])[-1])")

behind=()
status() {
  if [ "$2" = "$3" ]; then
    printf -v "$1" current
  else
    printf -v "$1" BEHIND
    behind+=("$4")
  fi
}

status node_status "$node_pin" "$node_latest" node
status yarn_status "$yarn_pin" "$yarn_latest" yarn
status types_status "$types_pin" "$types_latest" @types/node

printf '%-14s %-12s %-12s %s\n' TOOL PINNED LATEST STATUS
printf '%-14s %-12s %-12s %s\n' node "$node_pin" "$node_latest" "$node_status"
printf '%-14s %-12s %-12s %s\n' yarn "$yarn_pin" "$yarn_latest" "$yarn_status"
printf '%-14s %-12s %-12s %s\n' @types/node "$types_pin" "$types_latest" "$types_status"

if [ "$node_pin" != "$docker_pin" ]; then
  echo
  echo "MISMATCH: Dockerfile pins $docker_pin, .tool-versions pins $node_pin. Resync them."
fi

echo
if [ ${#behind[@]} -eq 0 ]; then
  echo "All current. Report this and stop."
else
  echo "Behind: ${behind[*]}"
fi
