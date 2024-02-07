" vim settings
set nocompatible

" Sound and visual bell
set belloff=all

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
"set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4


" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase
set smartindent

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

set laststatus=2

set hidden

" System clipboard
set clipboard=unnamedplus

" set mouse control
set mouse=a

" make vsplit put the new buffer on the right of the current buffer:
set splitright

" make split put the new buffer below the current buffer:
set splitbelow

" Set wildmenu command search and prompt
set wildmenu
set wildmode=longest:full,full
set statusline=%f\:%l\:%c\ \[%L\]


so ~/.vim/plugins.vim

" color schema and overrides
set t_Co=256    " Force Vim to use 256 colors
set encoding=UTF-8
colorscheme deep-space
" autocmd ColorScheme * highlight Visual ctermfg=white ctermbg=darkgrey cterm=NONE
let g:rainbow_active = 1
" set colum color dark grey
autocmd ColorScheme * highlight ColorColumn ctermbg=black guibg=darkgrey


" airline config
let g:airline_theme='sol'
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1

" NerdTree
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '~'
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" Highlight trailing whitespace
highlight ShowWhitespace ctermbg=white guibg=white
autocmd ColorScheme * match ShowWhitespace /\s\+$/
autocmd InsertEnter * match none
autocmd InsertLeave * match ShowWhitespace /\s\+$/


" intendguides plugin config
let g:indent_guides_auto_colors=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key mappings
"'"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-q> :NERDTreeToggle<CR> " NERDTree toggle
nnoremap <C-f> :Files<CR>
nnoremap <Tab> gt<CR> " Next tab
nnoremap <S-Tab> :tabnew<CR> " New tab
nnoremap <S-q> :q!<CR> " Quit without saving
nnoremap <C-x> :bp\|bd #<CR>
inoremap <C-z> <Esc>ui 
inoremap <C-s> <Esc>:w<CR> " Save file
vnoremap <C-s> <Esc>:w<CR> " Save file
nnoremap <C-s> :w<CR>  " Save file
nnoremap <C-a> ggVG<CR> " Select all
nnoremap <silent> <S-f> :RG<CR>
nnoremap <F1> :bel terminal ++rows=10<CR>
nnoremap <C-b> :Buffers<CR>
" vnoremap <RightMouse> :w !xclip -selection clipboard<CR><CR>
" Map the right-click (in visual mode) to copy to clipboard with xclip
vnoremap <RightMouse> :<C-u>
                       \echo 'Copy to clipboard...'<CR>
                       \:'<,'>w !xclip -selection clipboard<CR><CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader key mappings
" let mapleader = 
"'""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap <Leader><Leader> <Esc> " Map qq to escape in visual mode
inoremap <Leader><Leader> <Esc> " Map qq to escape in insert mode
tnoremap <Leader>tn <C-w><S-n> " Remap tn to switch term to normal mode
nnoremap <Leader>f gg=G " format file
nnoremap <Leader>v :vsplit NEW<CR> " Split window vertically and open new file
nnoremap <Leader>d :norm! yyP<CR> " Duplicate line
nnoremap <Leader>b :bn<CR> " Next buffer
map <Leader>1 ddkP<CR>  " Swap current line with the line above
nmap <Leader>c gcc<CR> " comment line
map <Leader>vf :VsplitVifm<CR>


" Search and replace word under cursor
noremap ;; :%s:<c-r><c-w>::gc<Left><Left><Left>
vnoremap ;; y:%s:<c-r>"::gc<Left><Left><Left>

map <S-Left> <C-W><Left> " Swap splits with Shift + arrow key
map <S-Right> <C-W><Right>

" Alias git status
cmap git :Git 

" Automatically add closing ( { [ ' " visual mode use S and {[(
inoremap <Leader>{ { }<Left>
inoremap <Leader>( ( )<Left>
inoremap <Leader>[ [ ]<Left>
inoremap <Leader>' ''<Left>
inoremap <Leader>" ""<Left>
nmap <leader>( ysiw(
nmap <leader>{ ysiw{
nmap <leader>[ ysiw[ 
nmap <leader>" ysiw" 
nmap <leader>' ysiw' 
" Commands
command -nargs=1 Count :%s/<args>//gn " Count number of matches
command! Jq :%!jq '.'
