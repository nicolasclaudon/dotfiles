claude-dockerize() {
  local dir="${1:-.}"
  
  mkdir -p "$dir"
  
  cat > "$dir/Dockerfile" <<'EOF'
FROM node:20-slim
RUN useradd -m -u 1001 claude
RUN npm install -g @anthropic-ai/claude-code
WORKDIR /workspace
USER claude
ENTRYPOINT ["claude"]
EOF

  echo "Dockerfile created in $dir"
}

claude-run() {
  local base_url="${1:-}"
  local image="claude-code"
  local dockerfile_dir="${CLAUDE_DOCKER_DIR:-$(pwd)}"

  if [[ ! -f "$dockerfile_dir/Dockerfile" ]]; then
    echo "No Dockerfile found in $dockerfile_dir, creating one..."
    claude-dockerize "$dockerfile_dir"
  fi

  if [[ -z "$ANTHROPIC_API_KEY" ]]; then
    echo "Error: ANTHROPIC_API_KEY is not set"
    return 1
  fi

  docker build -t "$image" "$dockerfile_dir" -q

  local env_flags="-e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY"
  [[ -n "$base_url" ]] && env_flags+=" -e ANTHROPIC_BASE_URL=$base_url"

  docker run -it \
    $env_flags \
    -v "$(pwd):/workspace" \
    "$image" --dangerously-skip-permissions
}

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


