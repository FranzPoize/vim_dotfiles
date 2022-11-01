local api = vim.api
local opt = vim.o
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "
g.splitbelow = true
g.splitright = true

opt.wrap = false
opt.linebreak = true -- Wraps lines a words
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.termguicolors = true
opt.hlsearch = true
opt.showmatch = true
opt.incsearch = true
opt.number = true
opt.timeoutlen = 300
opt.mousemode = 'a'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.swapfile = false

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]
