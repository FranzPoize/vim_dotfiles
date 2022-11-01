local keymap = vim.keymap.set
local default_opts = {noremap = true, silent = true}

local M = {}

function M.setup()
    local dap = require('dap')
    local dapui = require("dapui")

    dap.adapters.cpp = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
        name = 'lldb',
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        vim.api.nvim_exec(':bdelete! \\[dap-repl]', false)
    end

    function breaks()
        dap.list_breakpoints()
        vim.cmd [[TroubleToggle quickfix]]
    end

    vim.api.nvim_create_user_command('Breaks', 'lua breaks()', {})

    local dap_breakpoint = {
        error = {
            text = "🟥",
            texthl = "DiagnosticSignError",
            linehl = "",
            numhl = "",
        },
        rejected = {
            text = "",
            texthl = "DiagnosticSignHint",
            linehl = "",
            numhl = "",
        },
        stopped = {
            text = "⭐️",
            texthl = "DiagnosticsSignInformation",
            linehl = "DiagnosticUnderlineInfo",
            numhl = "DiagnosticSignInformation",
        },
    }

    vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
    vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
    vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

    keymap('n', '<leader>b', dap.toggle_breakpoint, default_opts)
    keymap('n', '<leader>B', function() vim.ui.input({}, dap.set_breakpoint) end, default_opts)
    keymap('n', '<leader>L', function() vim.ui.input({}, function(input) dap.set_breakpoint(nil, nil, input) end) end , default_opts)
    keymap('n', '<F5>', dap.continue, default_opts)
    keymap('n', '<F6>', dap.step_over, default_opts)
    keymap('n', '<F7>', dap.step_into, default_opts)
    keymap('n', '<F8>', dap.step_out, default_opts)
    keymap('n', '<leader>dl', dap.run_last, default_opts)

    dapui.setup()
end

return M
