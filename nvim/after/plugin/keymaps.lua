local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local remap_opts = { noremap = false, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }


keymap('n', '&', '1', default_opts)
keymap('n', '1', '&', default_opts)
keymap('n', 'é', '2', default_opts)
keymap('n', '2', 'é', default_opts)
keymap('n', '"', '3', default_opts)
keymap('n', '3', '"', default_opts)
keymap('n', "'", '4', default_opts)
keymap('n', '4', "'", default_opts)
keymap('n', '(', '5', default_opts)
keymap('n', '5', '(', default_opts)
keymap('n', '-', '6', default_opts)
keymap('n', '6', '-', default_opts)
keymap('n', 'è', '7', default_opts)
keymap('n', '7', 'è', default_opts)
keymap('n', '_', '8', default_opts)
keymap('n', '8', '_', default_opts)
keymap('n', 'ç', '9', default_opts)
keymap('n', '9', '(', default_opts)
keymap('n', 'à', '0', default_opts)
keymap('n', '0', ')', default_opts)

-- Better escape from normal and terminal mode
keymap('i', 'kj', '<ESC>', default_opts)
keymap('t', 'kj', '<c-\\><c-n>', default_opts)

-- Clear search buffer
keymap('n', ',/', '<cmd>:noh<cr>', default_opts)

-- Paste over currently selected text
keymap("v", "p", '"_dP', default_opts)

-- Better indenting (no deselect)
keymap('x', '<', '<gv', default_opts)
keymap('x', '>', '>gv', default_opts)

-- Find and replace
keymap('n', '<leader>fr', ':%s///g<left><left><left>', {})
keymap('n', '<leader>fl', ':s///g<left><left><left>', {})
keymap('n', '<leader>fl', ':s///g<left><left><left>', {})

-- alt file
keymap('n', '<s-u>', '<c-^>', default_opts)

-- Move line in visual selected mode
keymap("x", "K", ":move '<-2<CR>gv-gv", default_opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", default_opts)

-- Visual line wraps
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

-- Resizing panes
keymap("n", "<Left>", ":vertical resize +1<CR>", default_opts)
keymap("n", "<Right>", ":vertical resize -1<CR>", default_opts)
keymap("n", "<Up>", ":resize -1<CR>", default_opts)
keymap("n", "<Down>", ":resize +1<CR>", default_opts)

-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.

-- Harpoon
keymap('n', '<leader>u', '<cmd>UndotreeToggle<cr>', default_opts)
keymap('n', '<leader>j', '<cmd>lua require("harpoon.mark").add_file()<cr>', default_opts)
keymap('n', '<leader>k', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', default_opts)

keymap('n', '<c-j>', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', default_opts)
keymap('n', '<c-k>', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', default_opts)
keymap('n', '<c-l>', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', default_opts)
keymap('n', '<c-h>', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', default_opts)

keymap('n', '<leader>Q', 'q:', default_opts)
keymap('n', 'q:', '', default_opts)
keymap('n', '<leader>/', 'q/', default_opts)
keymap('n', 'q/', '', default_opts)
keymap('n', '<leader>?', 'q?', default_opts)
keymap('n', 'q?', '', default_opts)


vim.keymap.set('n', '[c', vim.diagnostic.goto_prev, default_opts)
vim.keymap.set('n', ']c', vim.diagnostic.goto_next, default_opts)
vim.keymap.set('n', '<leader>z', vim.diagnostic.setloclist, default_opts)
vim.keymap.set('n', '<leader>A', vim.diagnostic.open_float, {buffer = bufnr, noremap = true})
