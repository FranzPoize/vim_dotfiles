local M = {}

function M.setup()
    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'cpp', 'lua', 'cmake', 'python', 'fish', 'glsl', 'make', 'markdown' },
        auto_install = true,
        highlight = {
            enable = true,
        },
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
            colors = {
                '#333333',
                '#ff0000',
                '#00ff00',
                '#ffff00',
                '#0000ff',
                '#ff00ff',
                '#00ffff',
            }
        }
    }
end

return M
