#!/usr/bin/env bash
#
# NAME        - one-line description of what this script does
#
# Usage:
#   name [options] <args>
#
# Options:
#   -h, --help    Show this help and exit
#   -n, --dry-run Show what would happen without doing it
#
# Notes:
#   - Copy this file: `cp .template my-script && chmod +x my-script`
#   - Name it lowercase, hyphen-separated, no extension (e.g. `git-cleanup`).
#   - Read secrets from the environment or 1Password, never hardcode them.

set -euo pipefail

# Fail with a message on stderr and a non-zero exit code.
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
  # Print the leading comment block (after the shebang) as help text.
  awk 'NR==1{next} /^#/{sub(/^# ?/,""); print; next} {exit}' "$0"
}

dry_run=false

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)    usage; exit 0 ;;
    -n|--dry-run) dry_run=true; shift ;;
    --)           shift; break ;;
    -*)           die "unknown option: $1" ;;
    *)            break ;;
  esac
done

main() {
  # Require a dependency example:
  #   command -v jq >/dev/null || die "jq is required"

  if $dry_run; then
    echo "[dry-run] would do the thing with: $*"
    return 0
  fi

  echo "Hello from the template. Args: $*"
}

main "$@"
