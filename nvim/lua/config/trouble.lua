local M = {}

local whichkey = require('which-key')

function M.setup()
    -- Lsp config and mapping
    local leader_keymaps = {
        a = {
            name = 'Trouble',
            a = {"<cmd>TroubleToggle document_diagnostics<cr>", 'File diagnostics'},
            j = {"<cmd>TroubleToggle workspace_diagnostics<cr>", 'Workspace diagnostics'},
            q = {"<cmd>TroubleToggle quickfix<cr>", 'Quick fix'},
        },
    }

    whichkey.register(leader_keymaps, {
        mode = 'n',
        prefix = '<leader>',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
    })
end

return M

