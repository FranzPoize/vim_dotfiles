local M = {}

function M.setup()
    local whichkey = require('which-key')

    local conf = {
        window = {
            border = 'shadow',
            position = 'bottom',
        }
    }

    local opts = {
        mode = 'n',
        prefix = '<leader>',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
    }

    local mappings = {
        ["w"] = { "<cmd>update!<CR>", "Save" },
        ["q"] = { "<cmd>q!<CR>", "Quit" },

        f = {
            name = "Buffer",
            c = { "<Cmd>bd!<Cr>", "Close current buffer" },
            D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
        },

        z = {
            name = "Packer",
            c = { "<cmd>PackerCompile<cr>", "Compile" },
            i = { "<cmd>PackerInstall<cr>", "Install" },
            s = { "<cmd>PackerSync<cr>", "Sync" },
            S = { "<cmd>PackerStatus<cr>", "Status" },
            u = { "<cmd>PackerUpdate<cr>", "Update" },
        },
    }

    whichkey.setup(conf)
    whichkey.register(mappings, opts)
end

return M
