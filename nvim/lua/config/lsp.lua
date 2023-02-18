local keymap = vim.keymap.set
local default_opts = {noremap = true, silent = true}

local M = {}

vim.lsp.protocol.CompletionItemKind = {
    Text = " [text]",
    Method = " [method]",
    Function = " [function]",
    Constructor = " [constructor]",
    Field = "ﰠ [field]",
    Variable = " [variable]",
    Class = " [class]",
    Interface = " [interface]",
    Module = " [module]",
    Property = " [property]",
    Unit = " [unit]",
    Value = " [value]",
    Enum = " [enum]",
    Keyword = " [key]",
    Snippet = "﬌ [snippet]",
    Color = " [color]",
    File = " [file]",
    Reference = " [reference]",
    Folder = " [folder]",
    EnumMember = " [enum member]",
    Constant = " [constant]",
    Struct = " [struct]",
    Event = "⌘ [event]",
    Operator = " [operator]",
    TypeParameter = " [type]",
}

M.symbol_kind_icons = {
    Function = "",
    Method = "",
    Variable = "",
    Constant = "",
    Interface = "練",
    Field = "ﰠ",
    Property = "",
    Struct = "",
    Enum = "",
    Class = "",
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Constructor = "",
    String = "",
    Number = "",
    Boolean = "◩",
    Array = "",
    Object = "",
    Key = "",
    Null = "ﳠ",
    EnumMember = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

M.symbol_kind_colors = {
    Function = "green",
    Method = "green",
    Variable = "blue",
    Constant = "red",
    Interface = "cyan",
    Field = "blue",
    Property = "blue",
    Struct = "cyan",
    Enum = "yellow",
    Class = "magenta",
}

function M.setup()
    keymap('n', '[c', vim.diagnostic.goto_prev, default_opts)
    keymap('n', ']c', vim.diagnostic.goto_next, default_opts)
    keymap('n', '<leader>z', vim.diagnostic.setloclist, default_opts)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.fn.sign_define("DiagnosticSignError", { text = "", numhl = "DiagnosticError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "", numhl = "DiagnosticWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "", numhl = "DiagnosticInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", numhl = "DiagnosticHint" })

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
    local servers = { 'clangd', 'lua_ls'}

    for _, lsp in ipairs(servers) do
        require('lspconfig')[lsp].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            flags = lsp_flags,
        })
    end

    require('lspconfig').efm.setup({
        capabilities = capabilities,
        cmd = {"/usr/bin/efm-langserver"},
        on_attach = on_attach,
        init_options = {documentFormatting = true},
        root_dir = vim.loop.cwd,
        filetypes = {"python"},
        settings = {
            rootMarkers = {".git/"},
            lintDebounce = 100,
            languages = {
                python = {
                    {
                        formatCommand = "black --fast ${-l:lineLength} -",
                        formatStdin = true,
                    }
                }
            }
        }
    })

    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            update_in_insert = false,
        })(...)
        pcall(vim.diagnostic.setloclist, { open = false })
    end

    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    require('py_lsp').setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
    })
end

return M
