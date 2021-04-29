#!/bin/bash

DOT_FILES=( .zshrc .gitconfig .gitignore .tigrc .inputrc )
for file in ${DOT_FILES[@]}
do
    ln -s ~/dotfiles/$file ~/$file
done

touch ~/.zshrc.local

echo "Sucess!"
echo "Open a new shell/tab/terminal."
