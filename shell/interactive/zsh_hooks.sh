# zsh hooks for automatic title updates

# Only run in zsh
if [[ -n "$ZSH_VERSION" ]]; then
    # Function to update title on directory change
    chpwd() {
        set_window_title
    }

    # Set initial title when shell starts
    set_window_title
fi