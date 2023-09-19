local keymap = vim.keymap.set
local default_opts = {noremap = true, silent = true}

local M = {}

local dap = require('dap')
local dapui = require("dapui")
local whichkey = require('which-key')

function M.setup()

    -- dap.adapters.cpp = {
    --     type = 'executable',
    --     command = '/usr/bin/lldb-vscode',
    --     name = 'lldb',
    -- }

    dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = '/home/franz/.local/share/nvim/mason/bin/codelldb',
            args = {'--port', '${port}'},
        }
    }

    dap.configurations.cpp = {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    function breaks()
        dap.list_breakpoints()
        vim.cmd [[TroubleToggle quickfix]]
    end

    dap.defaults.cpp.exception_breakpoints = {'cpp_throw', 'raised'}

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

    local leader_keymaps = {
        ['b'] = {dap.toggle_breakpoint, "Toggle breakpoints"},
        ['B'] = {function() vim.ui.input({}, dap.set_breakpoint) end, "Set conditional breakpoint"},
        ['L'] = {function() vim.ui.input({}, function(input) dap.set_breakpoint(nil, nil, input) end) end, "Set log breakpoint"},
        d = {
            name = 'Debug',
            l = {dap.run_last, 'Run last'},
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

    local keymaps = {
        ['<F4>'] = {dap.pause, "Continue"},
        ['<F5>'] = {dap.continue, "Continue"},
        ['<F6>'] = {dap.step_over, "Step over"},
        ['<F7>'] = {dap.step_into, "Step into"},
        ['<F8>'] = {dap.step_out, "Step out"},
        ['<F9>'] = {dap.terminate, "Terminate"},
    }

    whichkey.register(keymaps, {
        mode = 'n',
        prefix = '',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
    })

    
    dapui.setup()
end

return M
