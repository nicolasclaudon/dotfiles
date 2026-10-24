function fabric --description 'fabric-ai with Anthropic key pulled from 1Password at runtime'
    # Pull the API key from 1Password only when needed.
    set -f key (op read "op://Personal/Anthropic Portfolio Token/credential")
    or begin
        echo "fabric: failed to read Anthropic key from 1Password (is 'op' signed in?)" >&2
        return 1
    end
    # Exported function-locally; fabric's .env loader won't override an already-set var.
    ANTHROPIC_API_KEY=$key command fabric-ai $argv
end
