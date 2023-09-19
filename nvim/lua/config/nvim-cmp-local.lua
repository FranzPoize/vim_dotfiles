local cmp = require "cmp"
local cmp_compare = require "config.cmp_compare"
local dev_icons = require "nvim-web-devicons"

local luasnip = require("luasnip")

cmp.setup {

    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    enabled = function()
        if (vim.bo.buftype ~= 'prompt' and not require('cmp.config.context').in_treesitter_capture('comment')
            and not require('cmp.config.context').in_syntax_group('Comment')) or require('cmp_dap').is_dap_buffer() then
            return true
        else
            return false
        end
    end,

    mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-5),
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-CR>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
        },
        ["<C-space>"] = function(fallback)
            if cmp.visible() then
                return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
            else
                return cmp.mapping.complete { reason = cmp.ContextReason.Auto }(fallback)
            end
        end,
        ["<tab>"] = function(fallback)
            if cmp.visible() then
                return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                return fallback()
            end
        end,
        ["<s-tab>"] = function(fallback)
            if cmp.visible() then
                cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }(fallback)
            elseif luasnip.jumpable(-1) then
                return luasnip.jump(-1)
            else
                return fallback()
            end
        end
    },

    sorting = {
        priority_weight = 100,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp_compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    sources = {
        { name = "path", priority_weight = 110 },
        { name = "dap", priority_weight = 110 },
        { name = "nvim_lsp", max_item_count = 20, priority_weight = 100 },
        { name = "nvim_lua", priority_weight = 90 },
        { name = "luasnip", priority_weight = 80 },
        { name = "buffer", max_item_count = 5, priority_weight = 70 },
        {
            name = "rg",
            keyword_length = 5,
            max_item_count = 5,
            priority_weight = 60,
            option = {
                additional_arguments = "--smart-case --hidden",
            },
        },
        { name = "tmux", max_item_count = 5, option = { all_panes = false }, priority_weight = 50 },
        {
            name = "look",
            keyword_length = 5,
            max_item_count = 5,
            option = { convert_case = true, loud = true },
            priority_weight = 40,
        },
    },

    formatting = {
        format = function(entry, vim_item)
            local menu_map = {
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[API]",
                path = "[Path]",
                luasnip = "[Snip]",
                tmux = "[Tmux]",
                look = "[Look]",
                rg = "[RG]",
                orgmode = "[ORG]",
                dap = "[DAP]",
            }
            vim_item.menu = menu_map[entry.source.name] or string.format("[%s]", entry.source.name)

            if vim_item.kind == "File" then
                vim_item.kind = dev_icons.get_icon(vim_item.word, nil, { default = true }) .. " [file]"
            else
                vim_item.kind = vim.lsp.protocol.CompletionItemKind[vim_item.kind]
            end

            return vim_item
        end,
    },

    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
    },

    experimental = {
        ghost_text = true,
    },
}

local cmdline_mappings = {
    select_next_item = {
        c = function(fallback)
            if cmp.visible() then
                return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
            else
                return cmp.mapping.complete { reason = cmp.ContextReason.Auto }(fallback)
            end
        end,
    },
    select_prev_item = {
        c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    },
}

cmp.setup.filetype({"dap-repl", "dapui_watches", "dapui_hover"}, {
    sources = {
        {name= "dap"},
    },
})

cmp.setup.cmdline(":", {
    mapping = {
        ["<C-n>"] = cmdline_mappings.select_next_item,
        ["<Tab>"] = cmdline_mappings.select_next_item,
        ["<C-p>"] = cmdline_mappings.select_prev_item,
        ["<S-Tab>"] = cmdline_mappings.select_prev_item,
    },
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }, {
        { name = "buffer" },
    }, {
        { name = "cmdline_history" },
    }),
})
cmp.setup.cmdline("/", {
    mapping = {
        ["<C-n>"] = cmdline_mappings.select_next_item,
        ["<Tab>"] = cmdline_mappings.select_next_item,
        ["<C-p>"] = cmdline_mappings.select_prev_item,
        ["<S-Tab>"] = cmdline_mappings.select_prev_item,
    },
    sources = cmp.config.sources({
        { name = "buffer" },
    }, {
        { name = "cmdline_history" },
    }),
})
