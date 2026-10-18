#!/usr/bin/env fish
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
#   - Copy this file: `cp .template.fish my-script && chmod +x my-script`
#   - Name it lowercase, hyphen-separated, no extension (e.g. `git-cleanup`).
#   - Read secrets from the environment or 1Password, never hardcode them.

# Fail with a message on stderr and a non-zero exit code.
function die
    printf 'error: %s\n' "$argv" >&2
    exit 1
end

function usage
    # Print the leading comment block (after the shebang) as help text.
    awk 'NR==1{next} /^#/{sub(/^# ?/,""); print; next} {exit}' (status filename)
end

# Parse options. `argparse` stops at the first non-option and leaves the rest
# in $argv. Flags become $_flag_<name> when present.
argparse h/help n/dry-run -- $argv
or exit 1

if set -q _flag_help
    usage
    exit 0
end

# Promote parsed options to globals so they're visible inside functions
# (fish functions do NOT inherit `local` vars from the calling scope).
set -g dry_run false
set -q _flag_dry_run; and set -g dry_run true

function main
    # Require a dependency example:
    #   command -q jq; or die "jq is required"

    if test "$dry_run" = true
        echo "[dry-run] would do the thing with: $argv"
        return 0
    end

    echo "Hello from the fish template. Args: $argv"
end

main $argv
