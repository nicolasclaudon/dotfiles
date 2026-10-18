# bin — personal scripts

Version-controlled personal scripts. Symlinked to `~/bin` by `install.sh`, which
is on `$PATH` (see `fish/config.fish`). Edits here are live immediately.

## Naming conventions

- **No extension** on the command name (`backup-db`, not `backup-db.sh`).
- **Lowercase, hyphen-separated**, verb-noun: `sync-photos`, `clean-cache`.
- **Namespace prefixes** to group related tools: `git-*`, `docker-*`.
  A script named `git-foo` is callable as `git foo`.
- **Don't shadow real commands** (no `ls`, `find`, ...).

## Writing scripts

Start from a template (both provide `--help` and `--dry-run`):

- Bash: `cp .template.bash my-script && chmod +x my-script`
- Fish: `cp .template.fish my-script && chmod +x my-script`

- Always a shebang: `#!/usr/bin/env bash` / `#!/usr/bin/env fish` (or `python3`, ...).
- Bash strict mode: `set -euo pipefail`.
- Fish: parse args with `argparse`; note that functions do **not** inherit
  `local` vars, so promote parsed flags to `-g` globals (see the template).
- Provide `--help` and a `--dry-run` for anything destructive.
- Commit the executable bit (`git update-index --chmod=+x <file>` if needed).
- Reach for Python once bash gets painful (>~100 lines, JSON, data structures).

## Secrets

Never commit tokens/keys. Read them at runtime, e.g. from 1Password:

```bash
GITHUB_TOKEN="$(op read 'op://Private/GitHub Token/credential')"
```

## Linting

```bash
shellcheck bin/*        # requires: brew install shellcheck
```

## Private / machine-specific scripts

Keep sensitive or one-machine-only scripts out of this repo (gitignore them or
use a separate private repo). Everything committed here is meant to be portable
and safe to share.
