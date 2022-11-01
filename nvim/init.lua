--           __
--   .--.--.|__|.--------.
--   |  |  ||  ||        |
--    \___/ |__||__|__|__|
--
-- By: Francois Poizat (@FranzP)

require('plugins').setup()

vim.cmd[[colorscheme tokyonight-storm]]

local opts = { noremap = true, silent = true }

local dap = require('dap')

local dapui = require("dapui")


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

require('wlsample.bubble')

-- Neo tree custom action

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
