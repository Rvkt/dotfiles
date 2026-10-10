# ----------------------------------------------------------------------
# ~/.bash_profile
# ----------------------------------------------------------------------

# Source ~/.bashrc if it exists
if [[ -f "$HOME/.bashrc" ]]; then
    . "$HOME/.bashrc"
fi

# ----------------------------------------------------------------------
# React Native JSON Logs
# ----------------------------------------------------------------------
rn-logs() {
    local bin=""
    if [ -x "$HOME/.local/bin/rn-logs" ]; then
        bin="$HOME/.local/bin/rn-logs"
    elif [ -x "$HOME/.dotfiles/bash/.local/bin/rn-logs" ]; then
        bin="$HOME/.dotfiles/bash/.local/bin/rn-logs"
    elif command -v rn-logs &>/dev/null && [ "$(type -t rn-logs)" != "function" ]; then
        bin="$(command -v rn-logs)"
    fi

    if [ -n "$bin" ]; then
        "$bin" "$@"
    else
        echo "Error: rn-logs executable not found." >&2
        return 1
    fi
}
rnlog() {
    rn-logs "$@"
}
rnlogs() {
    rn-logs "$@"
}
alias rnlog='rn-logs'
alias rnlogs='rn-logs'

