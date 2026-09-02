# zsh hooks for automatic title updates

# Only run in zsh
if [[ -n "$ZSH_VERSION" ]]; then
    update-followed-tab-title() {
        [[ -n "${ITERM_SESSION_TITLE_FOLLOW_MODE-}" ]] || return 0
        set-window-title
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd update-followed-tab-title

    if [[ -z "${ITERM_SESSION_TITLE_FOLLOW_MODE+x}" && -z "${ITERM_SESSION_TITLE-}" ]]; then
        set-tab-title-follow-branch
    fi
fi
