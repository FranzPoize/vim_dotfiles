local M = {}

local whichkey = require('which-key')

function M.setup()

    require('toggleterm').setup()
    -- build
    local Terminal = require('toggleterm.terminal').Terminal

    local function build(dir)
        local build_term = Terminal:new({
            dir = "~/gamedev" / dir,
            cmd = 'make -j 8', hidden = true, direction = 'horizontal',
            close_on_exit = false
        })
        build_term:toggle()
    end


    function _build_debug()
        build('build')
    end

    function _build_release()
        build('build_release')
    end

    --lazygit
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit  = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

    function _lazygit_toggle()
        lazygit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

    local leader_keymaps = {
        t = {
            name = 'Terminal',
            g = {"<cmd>lua _lazygit_toggle()<CR>", 'Open lazygit'},
            b = {"<cmd>lua _build_debug()<CR>", 'Build'},
            B = {"<cmd>lua _build_release()<CR>", 'Build'},
            n = {"<cmd>ToggleTerm<CR>", 'New Terminal'},
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
