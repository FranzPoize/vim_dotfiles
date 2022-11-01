local default_opts = {noremap = true, silent = true}
local keymap = vim.api.nvim_set_keymap

local M = {}

function M.setup()
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
            }
        }
    })

    keymap('n', '<c-n>', ':Neotree toggle<CR>', default_opts)
end

return M
