local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

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

-- Select buffer
keymap('n', '<s-l>', '<cmd>bp<cr>', default_opts)
keymap('n', '<s-h>', '<cmd>bn<cr>', default_opts)

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

-- Sane region switching
keymap('n', '<c-l>', '<c-w><c-l>', default_opts)
keymap('n', '<c-k>', '<c-w><c-k>', default_opts)
keymap('n', '<c-j>', '<c-w><c-j>', default_opts)
keymap('n', '<c-h>', '<c-w><c-h>', default_opts)
