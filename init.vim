set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'pangloss/vim-javascript'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'mxw/vim-jsx'
Plugin 'scrooloose/nerdtree'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-commentary'
Plugin 'flowtype/vim-flow'
call vundle#end()            " required
filetype plugin indent on    " required
inoremap kj <ESC>
inoremap <ESC> <NOP>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set number
set nowrap

set cursorline
set cursorcolumn

set background=dark
colorscheme solarized

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1

let g:flow#autoclose = 1
let g:flow#omnifunc = 1
let g:flow#enable = 1
let NERDTreeShowHidden = 1

let g:cltrp_custom_ignore = {
	\ 'dir': 'node_modules',
\ }

set wildignore+=*/node_modules/*

map <C-t> :NERDTreeToggle<CR>
map <c-o> :CtrlPBuffer<CR>
set undodir=~/.config/nvim/undodir
set undofile

if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
