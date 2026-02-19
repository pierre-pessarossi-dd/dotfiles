# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Install oh-my-zsh if not present
if [ ! -d "$ZSH" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

source $ZSH/oh-my-zsh.sh

# Point GOPATH to go sources
export GOPATH="$HOME/go"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"

# Point DATADOG_ROOT
export DATADOG_ROOT="$HOME/dd"

# Default editor
export EDITOR=vim
export VISUAL=vim

# Go configuration
export GO111MODULE=auto
export GOPRIVATE=github.com/DataDog
export GOPROXY=binaries.ddbuild.io,https://proxy.golang.org,direct
export GONOSUMDB=github.com/DataDog,go.ddbuild.io

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF keybindings
bindkey '^r' fzf-history-widget
bindkey '^g' fzf-cd-widget

# Fuzzy Git branch navigation
_fzf_complete_git() {
  local selected_branch
  selected_branch=$(git branch | fzf --height 40% --reverse --preview 'git log -n 5 --oneline {}' | sed 's/^[* ]*//')
  if [[ -n $selected_branch ]]; then
    LBUFFER="git checkout $selected_branch"
    zle accept-line
  fi
}
zle -N _fzf_complete_git
bindkey '^b' _fzf_complete_git

# Enable autocompletion
autoload -U compinit
compinit
alias ddpants='/home/bits/go/src/github.com/DataDog/dd-analytics/scripts/pants.sh'
