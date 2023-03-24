#!/bin/sh
echo -ne '\033c\033]0;Swarkat_Chowdown\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/SwartKat.x86_64" "$@"
