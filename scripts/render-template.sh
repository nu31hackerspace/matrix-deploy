#!/bin/sh
set -eu

: "${TEMPLATE_PATH:?TEMPLATE_PATH is required}"
: "${OUTPUT_PATH:?OUTPUT_PATH is required}"

mkdir -p "$(dirname "${OUTPUT_PATH}")"
perl -pe 's/\$\{(\w+)\}/exists $ENV{$1} ? $ENV{$1} : $&/ge' "${TEMPLATE_PATH}" > "${OUTPUT_PATH}"
