local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

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
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
        keymap('n', 'gh', vim.lsp.buf.implementation, bufopts)
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

    local lspconfig = require('lspconfig')

    require('lspconfig').lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
    })

    require('lspconfig').clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
        cmd = {"clangd", "-j", "4"}
    })

    -- require('lspconfig').pyright.setup({
    --     capabilities = capabilities,
    --     on_attach = on_attach,
    --     flags = lsp_flags,
    --     root_dir = function()
    --         return vim.fn.getcwd()
    --     end
    -- })

    require('lspconfig').glslls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
    })

    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            update_in_insert = false,
        })(...)
        pcall(vim.diagnostic.setloclist, { open = false })
    end

    local pylint = {
        lintCommand = "pylint --load-plugins=pylint_odoo --output-format text --score no --msg-template {path}:{line}:{column}:{C}:{msg} ${INPUT}",
        lintStdin = false,
        lintFormats = {
            "%f:%l:%c:%t:%m",
        },
        lintOffsetColumns = 1,
        lintCategoryMap = {
            I = "H",
            R = "I",
            C = "I",
            W = "W",
            E = "E",
            F = "E",
        },
    }

    local isort = {
        formatCommand = "isort --stdout ${-l:lineLength} --profile black -",
        formatStdin = true,
    }

    local black = {
        formatCommand = "black --quiet ${-l:lineLength} -",
        formatStdin = true,
    }

    local languages = {
        python = { black, isort, pylint },
    }

    lspconfig.efm.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = { documentFormatting = true },
        root_dir = vim.loop.cwd,
        filetypes = vim.tbl_keys(languages),
        settings = {
            rootMarkers = { ".git/" },
            lintDebounce = 100,
            languages = languages,
        }
    })

    vim.lsp.set_log_level(vim.log.levels.OFF)

    -- vim.fn.sign_define("DiagnosticSignError", { text = "", numhl = "DiagnosticError" })
    -- vim.fn.sign_define("DiagnosticSignWarn", { text = "", numhl = "DiagnosticWarn" })
    -- vim.fn.sign_define("DiagnosticSignInfo", { text = "", numhl = "DiagnosticInfo" })
    -- vim.fn.sign_define("DiagnosticSignHint", { text = "", numhl = "DiagnosticHint" })


    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

return M
