local M = {}

local whichkey = require('which-key')

function M.setup()
    whichkey.register({
        ['y'] = {'<cmd>PyLspFindVenvs<cr>', 'Find virtual env'}
    },
    {
        mode = 'n',
        prefix = '<leader>',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
    })
end

return M
