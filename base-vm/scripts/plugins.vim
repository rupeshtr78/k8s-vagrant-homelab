call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug 'dikiaap/minimalist'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'github/copilot.vim'    
Plug 'hashivim/vim-terraform'
Plug 'vifm/vifm.vim'
call plug#end()
