# zsh hooks for automatic title updates

# Only run in zsh
if [[ -n "$ZSH_VERSION" ]]; then
    # Function to update title on directory change
    chpwd() {
        set-window-title
    }

    # Set initial title when shell starts
    set-window-title
fi