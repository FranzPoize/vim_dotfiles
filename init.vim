set nocompatible              " be iMproved, required
filetype off                  " required


filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt+=longest,menuone

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <TAB> pumvisible() ? '<Down>' : '<Tab>'
inoremap <expr> <S-TAB> pumvisible() ? '<Up>' : '<S-Tab>'

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
Plugin 'jparise/vim-graphql'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/AutoComplPop'
Plugin 'ternjs/tern_for_vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'scrooloose/nerdtree'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'LucHermitte/lh-vim-lib'
Plugin 'LucHermitte/local_vimrc'
Plugin 'kyuhi/vim-emoji-complete'
Plugin 'dense-analysis/ale'
Plugin 'lifepillar/vim-solarized8'
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

set termguicolors
colorscheme solarized8

let b:ale_fixers = ['prettier', 'eslint']
let g:ale_open_list = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_fix_on_save = 1

let g:jsx_ext_required = 0

let NERDTreeShowHidden = 1

let g:cltrp_custom_ignore = {
	\ 'dir': 'node_modules',
\ }

set wildignore+=*/node_modules/*

map <C-t> :NERDTreeToggle<CR>
map <c-o> :CtrlPBuffer<CR>
set undodir=~/.config/nvim/undodir
set undofile

set hidden

set autoread
function! SyntasticCheckHook(errors)
  checktime
endfunction


set pastetoggle=<F2>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <silent> ,/ :nohlsearch<CR>

command! TransformPTF execute "arg src/**/*.coffee | silent argdo g/expand: O/normal f:lmaf(%dd`ad$"
command! RemovePoint execute 'arg src/**/*.coffee | silent argdo g/nodes\[\d\+\]\.\(expandedTo\[\d\+\]\.\)\?point/execute "normal! /point\<CR>hde"'
command! FixLineAngle execute 'arg src/**/*.coffee | silent argdo g/lineAngle([^{]/execute "normal :s/\\s)/)/g\<CR>:s/(\\s/(/g\<CR>:s/\\s,/,/g\<CR>/lineAngle\<CR>/cont\<CR>yt,i{x: kjf,i.x, y: kjpa.y}kjnyt)i{x: kjt)a.x, y: kjpa.y}kj"'
command! FixOneLineAngle execute 'g/lineAngle([^{]/execute "normal /lineAngle\<CR>:s/\\s)/)/g\<CR>:s/(\\s/(/g\<CR>:s/\\s,/,/g\<CR>/lineAngle\<CR>/cont\<CR>yt,i{x: kjf,i.x, y: kjpa.y}kjnyt)i{x: kjt)a.x, y: kjpa.y}kj"'
command! FixAnchorsComponents execute 'arg src/**/*.coffee | silent argdo execute "normal G/components\<CR>VG:s/anchors\\[\\([0123456]\\)]\\.\\([xy]\\)/parentAnchors[\\1].\\2/g\<CR>"'
command! FixOneAnchorsComponents execute "normal G/components\<CR>VG:s/anchors\\[\\([012345]\\)]\\.\\([xy]\\)/parentAnchors[\1].\\2/g\<CR>"
command! RemoveDeg execute 'arg src/**/*.coffee | silent argdo CmDegPy'

if !has('python')
	finish
endif

function! s:testDegPy()
	pyfile  ~/.config/nvim/fixDeg.py
endfunc

command! CmDegPy call s:testDegPy()

set tabstop=2
set shiftwidth=2
set expandtab
