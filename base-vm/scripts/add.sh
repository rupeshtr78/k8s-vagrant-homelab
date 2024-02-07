#!/bin/bash
# Add vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Fzf Install
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
echo "Fzf Version" $(fzf --version)
# Create .vim directory if it doesn't exist
mkdir -p ~/.vim

# Copy .vmrc and .vim/plugins.vim files to ~/.vim directory
cp .vimrc ~/.vim/
cp plugins.vim ~/.vim/

