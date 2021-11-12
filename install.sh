#!/bin/bash

# backup
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

DOT_FILES=( .zshrc .gitconfig .gitignore .tigrc .inputrc )
for file in ${DOT_FILES[@]}
do
    ln -s ~/dotfiles/$file ~/$file
done

cp .zshrc.local ~/.zshrc.local

echo "Sucess!"
echo "Open a new shell/tab/terminal."
