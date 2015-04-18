#!/bin/bash
set -e
[ -z "$SOD_ROOT" -a -d sod -a -f sod.sh ] && SOD_ROOT=sod
SOD_ROOT="${SOD_ROOT:-/opt/sod}"
export BUNDLE_GEMFILE="$SOD_ROOT/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG
exec "$SOD_ROOT/ruby/bin/ruby" -rbundler/setup "$SOD_ROOT/bin/sod" $@