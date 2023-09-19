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
opt.hlsearch = false
opt.showmatch = true
opt.incsearch = true
opt.number = true
opt.relativenumber = true
opt.timeoutlen = 300
opt.mouse = ''
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.swapfile = false

opt.scrolloff = 8

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

vim.filetype.add({
    extension = {
        vert = 'glsl',
        frag = 'glsl'
    }
})
