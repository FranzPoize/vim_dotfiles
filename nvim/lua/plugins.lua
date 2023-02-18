local M = {}

function M.setup()
    -- Indicate first time installation
    local packer_bootstrap = false

    -- packer.nvim configuration
    local conf = {
        display = {
            open_fn = function()
                return require("packer.util").float { border = "rounded" }
            end,
        },
    }

    -- Check if packer.nvim is installed
    -- Run PackerCompile if there are changes in this file
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap = fn.system {
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
            }
            vim.cmd [[packadd packer.nvim]]
        end
        vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
    end

    local function plugins(use)
        use 'wbthomason/packer.nvim'
        use 'folke/tokyonight.nvim'



        use 'kyazdani42/nvim-web-devicons'

        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
        use {
            'nvim-neo-tree/neo-tree.nvim', -- file tree viewer
            branch = 'v2.x',
            requires = {
                'nvim-lua/plenary.nvim',
                'kyazdani42/nvim-web-devicons',
                'MunifTanjim/nui.nvim',
            },
            config = function()
                require('config.neotree').setup()
            end,

        }
        use {
            "lvimuser/lsp-inlayhints.nvim",
            config = function()
                require("lsp-inlayhints").setup {
                    inlay_hints = {
                        parameter_hints = {
                            prefix = " <- ",
                            remove_colon_start = true,
                        },
                        type_hints = {
                            prefix = " ",
                            remove_colon_start = true,
                        },
                    },
                }
            end,
        }

        use {
            "hrsh7th/nvim-cmp",
            requires = {
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-path" },
                { "hrsh7th/cmp-nvim-lua" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "saadparwaiz1/cmp_luasnip" },
                { "hrsh7th/cmp-cmdline" },
                { "dmitmel/cmp-cmdline-history" },
                { "octaltree/cmp-look" },
                { "rcarriga/cmp-dap" },
                { "petertriho/cmp-git" },
                { "lttr/cmp-jira" },
            },
            config = "require 'config.nvim-cmp-local'",
        }

        use {
            "L3MON4D3/LuaSnip",
            config = function()
                require("luasnip").config.set_config {
                    history = true,
                    enable_autosnippets = true,
                    updateevents = "TextChanged,TextChangedI",
                    delete_check_events = "TextChanged",
                    ext_opts = {
                        [require("luasnip.util.types").choiceNode] = {
                            active = {
                                virt_text = { { "↺", "markdownBold" } },
                            },
                        },
                    },
                }
            end,
        }

        -- toggle comments with ease
        use 'tpope/vim-commentary'

        use {
            'folke/which-key.nvim', -- get easy info about bindings
            config = function()
                require('config.whichkey').setup()
            end,
        }

        -- language server config for neovim lsp client
        use {
            'HallerPatrick/py_lsp.nvim',
            config = function()
                require('config.py_lsp').setup()
            end
        }
        use {
            'neovim/nvim-lspconfig',
            config = function()
                require('config.lsp').setup()
            end
        }
        use 'p00f/clangd_extensions.nvim'

        use {
            'akinsho/toggleterm.nvim', -- terminal stuff
            config = function()
                require('config.toggleterm').setup()
            end
        }

        -- -- fuzzy finder
        use { 'junegunn/fzf', run = './install --bin', }
        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.0',
            -- or                            , branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } },
            config = function()
                require('config.telescope').setup()
            end
        }

        use {
            'folke/trouble.nvim',
            config = function()
                require('config.trouble').setup()
            end
        }
        use {
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require('todo-comments').setup({
                    highlight = {
                        multiline_pattern = "^//.",
                    }
                })
            end
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            config = function()
                require('config.treesitter').setup()
            end,
        }
        use {
            'weilbith/nvim-code-action-menu',
            cmd = 'CodeActionMenu',
        }
        use 'mfussenegger/nvim-dap'
        use {
            'rcarriga/nvim-dap-ui',
            requires = {
                'mfussenegger/nvim-dap',
            },
            config = function()
                require('config.dap').setup()
            end
        }
        use 'Shatur/neovim-tasks'

        -- UI
        use 'stevearc/dressing.nvim'
        use 'romgrk/barbar.nvim'
        use {
            'windwp/windline.nvim',
            requires = {
                'lewis6991/gitsigns.nvim',
            },
            config = function()
               require('gitsigns').setup()
               require('config.windline')
            end
        }
        use 'mhinz/vim-startify'

        -- formatting
        use 'editorconfig/editorconfig-vim'

        if packer_bootstrap then
            print "Restart Neovim required after installation!"
            require('packer').sync()
        end

        -- lsp and dap installer
        use {
            'williamboman/mason.nvim',
            config = function()
                require('mason').setup()
            end,
        }

    end

    packer_init()

    local packer = require "packer"
    packer.init(conf)
    packer.startup(plugins)
end

return M
