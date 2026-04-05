
# Create a new Claude project with docs/ and symlink it to the vault
claude-project() {
  local project_name="$1"
  local project_dir="$HOME/code/$project_name"
  local vault_dir="$HOME/code/claude-vault"
  local link="$vault_dir/$project_name"

  if [ -z "$project_name" ]; then
    echo "Usage: claude-project <project-name>"
    return 1
  fi

  mkdir -p "$project_dir/docs"
  echo "[claude-project] Created $project_dir/docs"

  mkdir -p "$vault_dir"

  if [ -L "$link" ]; then
    echo "[claude-project] Symlink already exists: $link"
  else
    ln -s "$project_dir/docs" "$link"
    echo "[claude-project] Linked docs to vault: $link"
  fi

  cd "$project_dir"
}

# Sync all existing projects that have a docs/ dir into the vault
claude-vault-sync() {
  local base_dir="$HOME/code"
  local vault_dir="$HOME/code/claude-vault"

  mkdir -p "$vault_dir"

  find "$base_dir" -maxdepth 2 -type d -name "docs" | \
    grep -v "claude-vault" | \
    while read -r dir; do
      local project=$(basename "$(dirname "$dir")")
      local link="$vault_dir/$project"

      if [ -L "$link" ]; then
        echo "[skip] $project (already linked)"
      else
        ln -s "$dir" "$link"
        echo "[linked] $project"
      fi
    done
}


