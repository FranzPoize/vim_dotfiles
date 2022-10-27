--           __
--   .--.--.|__|.--------.
--   |  |  ||  ||        |
--    \___/ |__||__|__|__|
--
-- By: Francois Poizat (@FranzP)

vim.cmd [[packadd packer.nvim]]

-- Set leader
vim.g.mapleader = " "
vim.g.loaded_matchit = 1 -- Don't need it
vim.g.loaded_gzip = 1 -- Gzip is pointless
vim.g.loaded_zipPlugin = 1 -- zip is also pointless
vim.g.loaded_logipat = 1 -- No logs
vim.g.loaded_2html_plugin = 1 -- Disable 2html
vim.g.loaded_rrhelper = 1 -- I don't use r
vim.g.loaded_getscriptPlugin = 1 -- Dont need it
vim.g.loaded_tarPlugin = 1 -- Nope

require('packer').startup(function(use)
    -- toggle comments with ease
    use 'tpope/vim-commentary'

    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    use {
        'nvim-neo-tree/neo-tree.nvim', -- file tree viewer
        branch = 'v2.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        }
    }

    use {
        'folke/which-key.nvim', -- get easy info about bindings
        config = function()
            require('which-key').setup {
            }
        end
    }

    use 'neovim/nvim-lspconfig' -- language server config for neovim lsp client

    use 'akinsho/toggleterm.nvim' -- terminal stuff

    use 'junegunn/fzf'

    use 'editorconfig/editorconfig-vim'

    use 'folke/tokyonight.nvim'
    use 'itchyny/lightline.vim' -- status bar
    use 'mengelbrecht/lightline-bufferline'
    use 'mhinz/vim-startify'
end)

local opts = {noremap = true, silent = true}
vim.keymap.set('n', '<leader>a', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[c', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']c', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>z', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
-- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require('lspconfig').clangd.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

require('lspconfig').sumneko_lua.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

--Whitespace
vim.wo.wrap = true
vim.wo.linebreak = true -- Wraps lines a words
vim.wo.breakindent = true -- Consistent indent of wrapped linex
vim.bo.expandtab = true
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.autoindent = true
vim.g.noshiftround = true
vim.g.hlsearch = true
vim.g.incsearch = true
vim.g.smartcase = true
vim.g.showmatch = true


-- Keymaps

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.keymap.set('i', 'kj', '<ESC>', opts)

-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-N>' or t'<Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})

vim.keymap.set('t', '<leader><ESC>', '<C-\\><C-n>', opts)
vim.keymap.set('n', '<c-l>', '<c-w><c-l>', opts)
vim.keymap.set('n', '<c-k>', '<c-w><c-k>', opts)
vim.keymap.set('n', '<c-j>', '<c-w><c-j>', opts)
vim.keymap.set('n', '<c-h>', '<c-w><c-h>', opts)

vim.wo.number = true
vim.g.splitbelow = true
vim.g.splitright = true
vim.bo.undofile = true
vim.g.undodir = "~/.config/nvim/undo"

