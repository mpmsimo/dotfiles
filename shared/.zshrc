# =========================================
# User configuration
# =========================================
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$HOME/.local/bin:$HOME/bin"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
    export TERM='rxvt'
fi

# Configure SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# =========================================
# ZSH configuration
# =========================================
# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="sunaku"
source $ZSH/oh-my-zsh.sh

# Additional ZSH colorscheme
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U vcs_info && vcs_info

zmodload zsh/complist
zmodload zsh/terminfo

# setopt
setopt \
  autocd \
  ksh_glob \
  extendedglob \
  prompt_subst \
  inc_append_history

# =========================================
# ZSH plugins 
# =========================================
plugins=(
            autoenv
            git
            kubectl
        )

# =========================================
# Terminal settings
# =========================================
autoload -Uz compinit
compinit

# =========================================
# Keybindings
# =========================================
bindkey -v
bindkey "^R" history-incremental-search-backward

# =========================================
# Aliases
# =========================================
# k8's aliases
alias kc=kubectl
alias kce='vim ~/.kube/config'
alias kcd='kubectl describe'
alias kcon='kubectl config use-context'
alias kc3='kubectl config current-context'
alias kcg='kubectl get'

# utilties
alias diffy='diff -y --suppress-common-lines'
alias tf=terraform

# development
alias cv="$GOPATH/src/clairvoyance/bin/clairvoyance"
alias go2='cd $GOPATH/src'

### Kubernetes
function kl() {
     kubectl logs $* | jq -R --raw-output '. as $raw | try (fromjson | .timestamp.seconds |= todateiso8601 | "\(.timestamp.seconds) - \(.filename) - \(.severity) - \(.message)") catch $raw'
}

# =========================================
# Go 
# =========================================
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO15VENDOREXPERIMENT=1
export CGO_ENABLED=1

# =========================================
# Google Cloud
# =========================================
# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME'/google-cloud-sdk/path.zsh.inc' ]; then source $HOME'/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f $HOME'/google-cloud-sdk/completion.zsh.inc' ]; then source $HOME'/google-cloud-sdk/completion.zsh.inc'; fi

# =========================================
# Node
# =========================================
#export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# =========================================
# Homebrew for Linux
# https://docs.brew.sh/Homebrew-on-Linux
# =========================================
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# =========================================
# Final Block
# =========================================
# force SSH login on load - for my own sanity.
ssh-add

# Enable fuzzyfinder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
