
# Homebrew
LINUXBREW=/home/linuxbrew/.linuxbrew/bin/brew
if [ -e $LINUXBREW ]; then
  eval `$LINUXBREW shellenv`
  echo "Linuxbrew is available!"
fi

# zprezto
[ -f "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ] && source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"


# zprezto thme
autoload -Uz promptinit
promptinit
prompt powerline

# .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# exa
if [[ $(command -v exa) ]]; then
  alias e='exa --group --icons -s type'
  alias l=e
  alias ls=e
  alias ea='exa -a --group --icons -s type'
  alias la=ea
  alias ee='exa -aal --group --icons -s type'
  alias ll=ee
  alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --group --icons -s type'
  alias lt=et
  alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --group --icons -s type | less -r'
  alias lta=eta
fi

# bat
if [[ $(command -v exa) ]]; then
  alias cat='bat -p'
fi

# peco
function peco-history-selection() {
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\*?\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# git
if [[ $(command -v git) ]]; then
  alias g=git
fi

# neovim
if [[ $(command -v nvim) ]]; then
  alias vim=nvim
  alias vi=vim
fi

