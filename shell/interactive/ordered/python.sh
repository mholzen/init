if which brew >/dev/null 2>&1; then
    # Python Homebrew
    export PATH=$PATH:$(brew --prefix python)/libexec/bin
fi
