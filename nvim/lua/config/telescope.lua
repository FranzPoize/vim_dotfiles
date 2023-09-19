local default_opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local M = {}

local dap = require('dap')
local whichkey = require('which-key')


function M.setup()
    local telescope_builtin = require('telescope.builtin')

    require('telescope').setup({
        defaults = {
            layout_config = {
                horizontal = { prompt_position = 'top' }
                -- other layout configuration here
            },
            -- other defaults configuration here
            sorting_strategy = 'ascending',
        },
    })

    -- Debug exe picker
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local Path = require("plenary.path")

    -- Trying a telescope debug launcher
    debug_exe = function(opts)
        local opts = opts or {}
        opts.entry_maker = function(entry)
            local path_table = vim.split(Path:new(entry).filename, "/")
            return {
                value = entry,
                display = path_table[#path_table],
                ordinal = entry
            }
        end
        pickers.new(opts, {
            prompt_title = 'Debug executable',
            finder = finders.new_oneshot_job(
            { "find", ".", "-type", "f", "-executable", "-path", "*Debug*", "-path", "*clang*", "-name", "*-"}, opts),
            --finder = finders.new_oneshot_job({ "find", ".", "-type", "f", "-executable", "-p", "**/Debug/**", "-name", "*-", "-o", "-name", "*tests" }, opts),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    dap.run({
                        type = 'codelldb',
                        request = 'launch',
                        program = selection.value,
                        stopOnEntry = false,
                    })
                end)
                return true
            end,
        }):find()
    end



    local keymaps = {
        ['<c-p>'] = { telescope_builtin.find_files, "Open file" },
        ['<c-t>'] = { telescope_builtin.live_grep, "Search in files" },
        ['<c-m>'] = { telescope_builtin.buffers, "Open buffer" },
    }

    whichkey.register(keymaps,
        {
            mode = 'n',
            prefix = '',
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        })

    whichkey.register({
            ['R'] = { debug_exe, 'Debug exe picker' }
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
