
# Homebrew
HOMEBREW=/opt/homebrew/bin/brew
if [ -e $HOMEBREW ]; then
  eval `$HOMEBREW shellenv`
  echo "Homebrew is available!"
fi

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
