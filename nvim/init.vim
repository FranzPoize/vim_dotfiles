"           __
"   .--.--.|__|.--------.
"   |  |  ||  ||        |
"    \___/ |__||__|__|__|
"
" By: Avery Wagar (@ajmwagar)

" Setup Neovim: {{{

" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

"Set leader
:let mapleader = " "

" }}}
" Disable default plugins: {{{

let g:loaded_matchit = 1 " Don't need it
let g:loaded_gzip = 1 " Gzip is pointless
let g:loaded_zipPlugin = 1 " zip is also pointless
let g:loaded_logipat = 1 " No logs
let g:loaded_2html_plugin = 1 " Disable 2html
let g:loaded_rrhelper = 1 " I don't use r
let g:loaded_getscriptPlugin = 1 " Dont need it
let g:loaded_tarPlugin = 1 " Nope

" }}}
" Config: {{{
" Import Plugins: {{{
" Handle Plugins with minpac 
packadd minpac
if exists('*minpac#init')
  call minpac#init()

  " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
  " Fast plugin manager
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  function! DoRemote()
    UpdateRemotePlugins
  endfunction

  " Workflow plugins
  call minpac#add('sheerun/vim-polyglot') " Syntax files for most languages
  call minpac#add('tpope/vim-commentary') " Toggle comments with ease
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('nvim-neo-tree/neo-tree.nvim')
  call minpac#add('nvim-lua/plenary.nvim')
  call minpac#add('kyazdani42/nvim-web-devicons')
  call minpac#add('MunifTanjim/nui.nvim')
  call minpac#add('folke/trouble.nvim')
  call minpac#add('akinsho/toggleterm.nvim')
  call minpac#add('folke/which-key.nvim')

  " Searching/Fuzzy Finding
  call minpac#add('junegunn/fzf', { 'do': './install --all' }) | call minpac#add('junegunn/fzf.vim') " FZF <3's Vim

  " Autocomplete
  call minpac#add('neoclide/coc.nvim', {'branch': 'release'}) " Conquereer of Completions 
  call minpac#add('honza/vim-snippets') " Conquereer of Completions 

  " editorconfig
  call minpac#add('editorconfig/editorconfig-vim')

  " Editor plugins/UI
  call minpac#add('folke/tokyonight.nvim') " nord-vim-theme
  call minpac#add('mg979/vim-visual-multi') " multiple cursors
  call minpac#add('itchyny/lightline.vim') " Status bar
  call minpac#add('junegunn/goyo.vim', {'type': 'opt'})
  call minpac#add('mengelbrecht/lightline-bufferline')
  call minpac#add('mhinz/vim-startify')

endif
" }}}
" Plugin Config: {{{
" COC {{{

" let g:coc_force_debug = 1
"Better display for messages
set cmdheight=1
set noshowmode
set noruler
set noshowcmd

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

function! s:EditAlternate()
    let l:alter = CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand("%:p")})
    " remove file:/// from response
    let l:alter = substitute(l:alter, "file://", "", "")
    execute 'edit ' . l:alter
endfunction
autocmd FileType cpp nmap rn :call <SID>EditAlternate()<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd User CocDiagnosticChange silent call s:MaybeUpdateLightline()

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format)


augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocActionAsync('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" }}}
" fuzzy finder/ack Settings {{{
"Use ripgrep
let g:ackprg = 'rg --vimgrep --no-heading'
let g:grepprg='rg --vimgrep'

let $FZF_DEFAULT_OPTS='--reverse'

noremap <silent> <C-p> :Files<return>
noremap <silent> <C-t> :Rg<return>
noremap <silent> <C-m> :Buffers<cr>

"" }}}
"Lightline {{{ 
set showtabline=2

"
function! User()
  return system('echo -n $LOGNAME@$(cat /etc/hostname)')
  " . "@" . echo "silent !hostname"
endfunction

" use lightline-buffer in lightline
let g:lightline = {
      \ 'colorscheme': 'tokyonight-storm',
      \ 'component_expand': {
      \   'linter_warnings': 'CocWarnings',
      \   'linter_errors': 'CocErrors',
      \   'linter_ok': 'CocOK',
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'left',
      \   'time': 'left',
      \   'user': 'left',
      \   'buffers': 'tabsel',
      \ },
      \ 'component_function': {
      \   'wordcount': 'WordCount',
      \   'lsp': 'MiniStat',
      \   'time': 'Timer',
      \   'gitbranch': 'GitBranch',
      \   'filetype': 'Filetype',
      \   'user': 'User'
      \ },
      \ 'component': {
      \   'separator': ''
      \ },
      \ 'active': {
      \   'left': [['mode', 'paste'], ['gitbranch', 'filename', 'modified']],
      \   'right': [
      \             ['linter_ok'],
      \             ['lsp', 'linter_warnings', 'linter_errors'], 
      \             ['percent','lineinfo']
      \]
      \ }
      \ }

let g:lightline.tabline = {'left': [['buffers']], 'right': [['user', 'time']]}
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#unicode_symbols = 1

let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }

function! LightlineBufferline()
  call bufferline#refresh_status()
  return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
endfunction

function! MiniStat() abort
  return get(g:, 'coc_status', '')
endfunction

function! Timer()
  " return strftime("%H:%S")
  return strftime("%H:%M") . " PST" "Timer in status line
  " return !date
endfunction

function! GitBranch()
  if (FugitiveHead() != '')
    return FugitiveHead() . ' '
  endif
  return ''
endfunction


" Coc Linter functions

function! CocWarnings() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  return printf('%d', info['warning'])
endfunction

function! CocErrors() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  return printf('%d', info['error'])
endfunction


function! CocOK() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  return empty(info) ? '✓' : ''
endfunction


" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction
"       \ }

" lightline-buffer ui settings
" replace these symbols with ascii characters if your environment does not support unicode
let g:lightline_buffer_readonly_icon = ''
let g:lightline_buffer_modified_icon = '•'
let g:lightline_buffer_git_icon = ' '
let g:lightline_buffer_separator_icon = '  '

" max file name length
let g:lightline_buffer_maxflen = 30


" }}}
" Startify: {{{
let g:ascii = [
      \ '           __',
      \ '   .--.--.|__|.--------.',
      \ '   |  |  ||  ||        |',
      \ '    \___/ |__||__|__|__|',
      \ ''
      \]
let g:startify_custom_header = g:ascii
" }}}
" Packadd: {{{
" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" vim-visual-multi {{{
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
" }}}

" Neotree: {{{

map <C-n> :NeoTreeShowToggle <CR>

" }}}
" }}}
" Functional Config {{{
" Workflow: {{{
" define a fancy nvim clipboard provider
if has('linux')
  let g:clipboard = {
    \   'name': 'Vim Clipboard',
    \   'copy': {
    \      '+': 'xclip -i -selection clipboard',
    \      '*': 'xclip -i -selection secondary',
    \    },
    \   'paste': {
    \      '+': 'xclip -o -selection clipboard',
    \      '*': 'xclip -o -selection secondary',
    \   },
    \   'cache_enabled': 1,
    \ }
  " tell nvim to use * as its internal clipboard
  " now vim sessions can share yank buffers by using the virtually unheard of
  " secondary selection buffer!
  set clipboard=unnamed
endif


filetype off
" Turn on syntax highlighting
syntax on
" Security
set modelines=1
" Folding
set foldmethod=marker
set foldlevel=0
set number " Show line number
set relativenumber " Enable 'nybrid' line numbers
set mouse=n " Disable mouse in insert mode
set dictionary+=/usr/share/dict/words "Add  a dictionary
filetype plugin indent on " Turn on indeting

" Make vim more natural
set splitbelow " Split new panes below
set splitright " Vertical split new panes to the right

nmap <space>, :Vimrc<return>
nmap <C-,> :Vimrc<return>
if has('unix') 
  command! Vimrc edit /home/$USER/.config/nvim/init.vim
endif

set backspace=indent,eol,start " Use backspace in insert mode
set pdev=Brother_HL-4570CDW_series " Print from home
set noshowcmd
"" }}}
" Whitespace:{{{
set nowrap " Wrap lines
set linebreak " Wraps lines a words
set breakindent " Consistent indent of wrapped linex
" set textwidth=100 " Wrap at 100 chars
set expandtab " Use spaces instead of tab
set softtabstop=4 " Number of spaces per tab
set shiftwidth=4   " Number of auto indent spaces
set autoindent " Auto indent
set noshiftround " Indent lines by 2 not by nearest mutiple of two
" }}}
" Performance: {{{
" Different Cursor shape in tmux 
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set hidden " Allow hidden buffers
set ttyfast " Rendering
" }}}
" Searching: {{{
set hlsearch "  Highlight all search results
set incsearch " Searches the string incrementaly
set smartcase " Enable smart case 
set showmatch " Highlight matching brace
" }}}
" Persistent undo: {{{
if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backup files, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.config/nvim/undo') == 0
    :silent !mkdir -p ~/.config/nvim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo// " Set undodir
  set undodir+=~/.config/nvim/undo//
  set undofile " Create undofiles
endif

" Begone swapfiles
set directory^=$HOME/.config/nvim/tmp// " Disable swapfiles
set noswapfile " Begone
" }}}
"Terminal settings: {{{
autocmd TermOpen term://* startinsert
autocmd TermOpen term://* setlocal nonumber norelativenumber

" Make esc work
tnoremap <Leader><Esc> <C-\><C-n>

" Window navigation function
" Make ctrl-h/j/k/l move between windows and auto-insert in terminals
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["h", "j", "l", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor

"}}}
" }}}
" Colors {{{
" Fix colors in tmux
if !has('gui_running')
  " Font
  set guifont ="Knack Nerd Font"
  " Colors
  set termguicolors
  set t_Co=256
  let g:deus_termcolors=256
  let NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

set background=dark    " Setting dark mode
let g:deus_italics = 1
set fillchars+=vert:\ 
colorscheme tokyonight-storm


" }}}
"Mappings {{{
" Don't lose selection when shifting sidewards
xnoremap < <gv
xnoremap > >gv

vnoremap <silent> <Leader>is :<C-U>let old_reg_a=@a<CR>
 \:let old_reg=@"<CR>
 \gv"ay
 \:let @a=substitute(@a, '.\(.*\)\@=',
 \ '\=@a[strlen(submatch(1))]', 'g')<CR>
 \gvc<C-R>a<Esc>
 \:let @a=old_reg_a<CR>
 \:let @"=old_reg<CR>

" Switching Buffers
noremap <silent><leader>[ :bp<return>
noremap <silent><leader>] :bn<return>

nnoremap <silent>,/ :let @/=''<CR>

"Find and replace
map <leader>fr :%s///g<left><left>
" Find and replace on current line only
map <leader>frl :s///g<left><left>

" Move up/down editor lines
nnoremap <silent> j gj
nnoremap <silent> k gk

"Goyo
nnoremap <silent><leader>z :GoyoStart<return>

" Disable ex-mode 
nnoremap <silent>Q <nop> 

" kj to exit normal mode
inoremap kj <ESC>

" }}}
" Autocommands: {{{
augroup prose
  autocmd!
  autocmd FileType markdown set spell
  autocmd FileType text set spell
augroup end
" }}}
" }}}
"


