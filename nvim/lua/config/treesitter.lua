local M = {}

function M.setup()
    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'cpp', 'lua', 'cmake', 'python', 'fish', 'glsl', 'make', 'markdown' },
        auto_install = true,
        highlight = {
            enable = true,
        },
    }
end

return M
