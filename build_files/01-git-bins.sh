#!/bin/bash

set -xeuo pipefail

arch="x86_64"
libc="gnu"

while read -r repo bin; do
  [ -z "$repo" ] && continue

  api="https://api.github.com/repos/${repo}/releases/latest"

  urls=()
  while IFS= read -r line; do
    urls+=("$line")
  done < <(
    curl -sL "$api" |
    jq -r '.assets[].browser_download_url' |
    grep -Ei 'linux.*\.(tar\.gz|tgz)$'
  )

  url=""

  for u in "${urls[@]}"; do
    if [[ $u =~ "$arch" && $u =~ "$libc" ]]; then
      url="$u"
      break
    elif [[ $u =~ $arch ]]; then
      url="$u"
      break
    else
      [[ -z $url ]] && url="$u"
    fi
  done

  [ -z "$url" ] && { echo "No tarball found for $repo"; continue; }

  curl -L "$url" | tar -xz -C /tmp

  found=$(find /tmp -type f -name "$bin" -perm -111 | head -n1)
  install -m 0755 "$found" "/usr/bin/$bin"
  rm -f "/tmp/${bin}"
done </ctx/build/packages/git-bins

curl -fsSL https://raw.githubusercontent.com/alfonsosanchez12/ezpodman/main/ezpodman -o /usr/bin/ezpodman
chmod +x /usr/bin/ezpodman
