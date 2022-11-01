local keymap = vim.keymap.set
local default_opts = {noremap = true, silent = true}

local M = {}

function M.setup()
    keymap('n', '[c', vim.diagnostic.goto_prev, default_opts)
    keymap('n', ']c', vim.diagnostic.goto_next, default_opts)
    keymap('n', '<leader>z', vim.diagnostic.setloclist, default_opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        keymap('n', 'gD', vim.lsp.buf.declaration, bufopts)
        keymap('n', 'gd', vim.lsp.buf.definition, bufopts)
        keymap('n', 'K', vim.lsp.buf.hover, bufopts)
        keymap('n', 'gi', vim.lsp.buf.implementation, bufopts)
        keymap('n', '<leader>K', vim.lsp.buf.signature_help, bufopts)
        keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        keymap('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        keymap('n', 'gt', vim.lsp.buf.type_definition, bufopts)
        keymap('n', 'gn', vim.lsp.buf.rename, bufopts)
        keymap('n', '<leader>ca', '<cmd>CodeActionMenu<cr>', bufopts)
        keymap('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>', bufopts)
        keymap('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        keymap('n', 'rn', '<cmd>:ClangdSwitchSourceHeader<cr>', default_opts)
    end

    local lsp_flags = {
        -- This is the default in Nvim 0.7+
        debounce_text_changes = 150,
    }
    local servers = { 'clangd', 'sumneko_lua'}
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

    require('py_lsp').setup(require('coq').lsp_ensure_capabilities({
        on_attach = on_attach,
        flags = lsp_flags,
    }))
end

return M
