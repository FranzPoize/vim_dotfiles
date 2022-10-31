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

    use 'folke/which-key.nvim' -- get easy info about bindings

    use 'neovim/nvim-lspconfig' -- language server config for neovim lsp client
    use {
        'ms-jpq/coq_nvim',
        run = 'python3 -m coq deps',
        requires = {
            'ms-jpq/coq.artifacts',
            'ms-jpq/coq.thirdparty',
        }
    }
    use 'p00f/clangd_extensions.nvim'

    use 'akinsho/toggleterm.nvim' -- terminal stuff

    -- fuzzy finder
    use { 'junegunn/fzf', run = './install --bin', }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use 'folke/trouble.nvim'
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require('todo-comments').setup({
                highlight = {
                    multiline_pattern = "^//.",
                }
            })
        end
    }
    use 'nvim-treesitter/nvim-treesitter'
    use {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'Shatur/neovim-tasks'

    -- UI
    use 'stevearc/dressing.nvim'
    use 'romgrk/barbar.nvim'
    use 'folke/tokyonight.nvim'
    use {
        'windwp/windline.nvim',
        requires = {
            'lewis6991/gitsigns.nvim',
        }
    }
    use 'mhinz/vim-startify'
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

    -- formatting
    use 'editorconfig/editorconfig-vim'
end)
local opts = { noremap = true, silent = true }

local dap = require('dap')

dap.adapters.cpp = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb',
}

local dapui = require("dapui")

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    vim.api.nvim_exec(':bdelete! \\[dap-repl]', false)
end

function breaks()
    dap.list_breakpoints()
    vim.cmd [[TroubleToggle quickfix]]
end
vim.api.nvim_create_user_command('Breaks', 'lua breaks()', {})

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>B', function() vim.ui.input({}, dap.set_breakpoint) end, opts)
vim.keymap.set('n', '<leader>L', function() vim.ui.input({}, function(input) dap.set_breakpoint(nil, nil, input) end) end
    , opts)
vim.keymap.set('n', '<F5>', dap.continue, opts)
vim.keymap.set('n', '<F6>', dap.step_over, opts)
vim.keymap.set('n', '<F7>', dap.step_into, opts)
vim.keymap.set('n', '<F8>', dap.step_out, opts)
vim.keymap.set('n', '<leader>dl', dap.run_last, opts)
local dap_breakpoint = {
    error = {
        text = "🟥",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = "",
        texthl = "DiagnosticSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = "⭐️",
        texthl = "DiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "DiagnosticSignInformation",
    },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

-- dap.configurations.cpp = {
--     {
--         name = 'Launch',
--         type = 'lldb',
--         request = 'launch',
--         program = function()
--             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/'
--     },
-- }


-- Git
require('gitsigns').setup()

--Tree sitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'cpp', 'lua', 'cmake', 'python', 'fish', 'glsl', 'make', 'markdown' },
    auto_install = true,
    highlight = {
        enable = true,
    },
}

-- build
local Terminal = require('toggleterm.terminal').Terminal
local build    = Terminal:new({
    dir = "~/gamedev/build",
    cmd = 'make -j 8', hidden = true, direction = 'horizontal',
    close_on_exit = false
})

function _build_debug()
    build:toggle()
end

--lazygit
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

function _lazygit_toggle()
    lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- Lsp config and mapping
vim.keymap.set('n', '<leader>aa', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>aj', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>aq', '<cmd>TroubleToggle quickfix<cr>', opts)
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
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', '<cmd>CodeActionMenu<cr>', bufopts)
    vim.keymap.set('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>', bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.keymap.set('n', 'rn', '<cmd>:ClangdSwitchSourceHeader<cr>', opts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
local servers = { 'clangd', 'sumneko_lua', 'pyright' }
vim.g.coq_settings = {
    auto_start = 'shut-up',
    keymap = {
        jump_to_mark = '<c-e>',
    },
}

for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup(require('coq').lsp_ensure_capabilities({
        on_attach = on_attach,
        flags = lsp_flags,
    }))
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

--Whitespace
vim.o.wrap = false
vim.o.linebreak = true -- Wraps lines a words
vim.o.breakindent = true -- Consistent indent of wrapped linex
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.showmatch = true

-- Colorscheme
vim.api.nvim_exec(':colorscheme tokyonight-storm', false)

-- Keymaps

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.keymap.set('i', 'kj', '<ESC>', opts)
vim.keymap.set('n', ',/', '<cmd>:noh<cr>', opts)
vim.keymap.set('x', '<', '<gv', opts)
vim.keymap.set('x', '>', '>gv', opts)
vim.keymap.set('n', '<leader>fr', ':%s///g<left><left><left>', {})
vim.keymap.set('n', '<leader>fl', ':s///g<left><left><left>', {})
vim.keymap.set('n', '<leader>fl', ':s///g<left><left><left>', {})
vim.keymap.set('n', '<leader>l', '<cmd>bp<cr>', opts)
vim.keymap.set('n', '<leader>h', '<cmd>bn<cr>', opts)

-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t '<C-N>' or t '<Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', { expr = true, noremap = true })

vim.keymap.set('t', '<leader><ESC>', '<C-\\><C-n>', opts)
vim.keymap.set('n', '<c-l>', '<c-w><c-l>', opts)
vim.keymap.set('n', '<c-k>', '<c-w><c-k>', opts)
vim.keymap.set('n', '<c-j>', '<c-w><c-j>', opts)
vim.keymap.set('n', '<c-h>', '<c-w><c-h>', opts)
vim.keymap.set('n', '<c-n>', ':Neotree toggle<CR>', opts)

vim.wo.number = true
vim.g.splitbelow = true
vim.g.splitright = true
--
-- undodir
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.config/nvim/undo")

-- Disable swapfile
vim.o.swapfile = false

-- Telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-p>', telescope_builtin.find_files, opts)
vim.keymap.set('n', '<c-t>', telescope_builtin.live_grep, opts)
vim.keymap.set('n', '<c-m>', telescope_builtin.buffers, opts)

require('telescope').setup({
    defaults = {
        layout_config = {
            horizontal = { prompt_position = 'top' }
            -- other layout configuration here
        },
        -- other defaults configuration here
        sorting_strategy = 'ascending',
    },
})

require('which-key').setup()

require('wlsample.bubble')

-- Neo tree custom action
require("neo-tree").setup({
    filesystem = {
        commands = {
            print_me = function(state)
                local node = state.tree:get_node()
                print(node.path)
                dap.run({
                    type = 'cpp',
                    request = 'launch',
                    program = node.path,
                })
            end
        },
        window = {
            mappings = {
                ['<leader>M'] = 'print_me'
            }
        }
    }
})

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local Path = require("plenary.path")

-- startify
vim.g.startify_change_to_dir = 0
vim.g.startify_change_to_vcs_root = 0

-- Trying a telescope debug launcher
debug_exe = function(opts)
    opts = opts or {}
    opts.entry_maker = function(entry)
        local path_table = vim.split(Path:new(entry).filename, "/")
        return {
            value = entry,
            display = path_table[#path_table],
            ordinal = entry
        }
    end
    pickers.new(opts, {
        prompt_title = 'Debug executable',
        finder = finders.new_oneshot_job({ "find", ".", "-type", "f", "-perm", "/u=x,g=x,o=x", "-name", "*-" }, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                dap.run({
                    type = 'cpp',
                    request = 'launch',
                    program = selection.value,
                })
            end)
            return true
        end,
    }):find()
end

vim.keymap.set('n', '<leader>R', debug_exe, opts)
