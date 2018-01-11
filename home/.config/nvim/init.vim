" Plug {{{
call plug#begin('~/.config/nvim/plugged')

" Autocomplete
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'roxma/nvim-completion-manager'
Plug 'roxma/python-support.nvim'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'jlanzarotta/bufexplorer'
Plug 'elmcast/elm-vim'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
"Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
"Plug 'mattn/emmet-vim'
"
" Async linting
"Plug 'neomake/neomake'
"
" Vim, Tmux, and Airline theming
Plug 'vim-airline/vim-airline'
"Plug 'dracula/vim'

" Install polyglot for language plugins
Plug 'sheerun/vim-polyglot'

call plug#end()
" }}}


"" Base Configuration {{{
set nocompatible
"filetype off
filetype plugin indent on

set ttyfast

"set laststatus=2
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
set autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch

"" Basic vim settings
set hidden
set visualbell
set number
"set nobackup
"set noswapfile
"set noshowmode

"" Set the terminal's title
set title

" Global tab width.
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Set to show invisibles (tabs & trailing spaces) & their highlight color
set list listchars=tab:»\ ,trail:·

" Configure spell checking
nmap <silent> <leader>p :set spell!<CR>
set spelllang=en_us

" Set leader to comma
let mapleader = ","

"" Send all vim registers to the mac clipboard
"set clipboard=unnamed
"
"" Default to magic mode when using substitution
"cnoremap %s/ %s/\v
"cnoremap \>s/ \>s/\v
"" }}}
"
"" Terminal Mode Configuration {{{
"" Terminal mode mfappings
"tnoremap <Esc> <C-\><C-n>
" }}}
