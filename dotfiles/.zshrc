source /etc/antigen/antigen.zsh

# plugins
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle lukechilds/zsh-nvm
# theme
antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

# Commit Antigen Configuration
antigen apply

export GRDIR=/tools/graudit/signatures
export PATH="/etc/poetry:/tools/graudit:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

alias cat="batcat"
alias ls="exa"