if command -v brew >/dev/null 2>&1; then
    # Python Homebrew
    export PATH=$PATH:$(brew --prefix python)/libexec/bin
fi

python_base=$(python3 -m site --user-base)
if [ -d "$python_base/bin" ]; then
    export PATH=$PATH:$python_base/bin
fi