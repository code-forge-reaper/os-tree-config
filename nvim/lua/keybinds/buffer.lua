-- Enable completion triggered by <c-x><c-o>
vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
local opts = { noremap = true, silent = true }

-- Mappings.
-- See :help vim.lsp.* for documentation on any of the below functions
keymap('n', 'gD', 'lua vim.lsp.buf.declaration()', opts)
keymap('n', 'gd', 'lua vim.lsp.buf.definition()', opts)
keymap('n', 'K', 'lua vim.lsp.buf.hover()', opts)
keymap('n', 'gi', 'lua vim.lsp.buf.implementation()', opts)
keymap('n', '<C-k>', 'lua vim.lsp.buf.signature_help()', opts)
keymap('n', '<leader>wa', 'lua vim.lsp.buf.add_workspace_folder()', opts)
keymap('n', '<leader>wr', 'lua vim.lsp.buf.remove_workspace_folder()', opts)
keymap('n', '<leader>wl',
    'lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))', opts)
keymap('n', '<leader>D', 'lua vim.lsp.buf.type_definition()', opts)
keymap('n', '<leader>rn', 'lua vim.lsp.buf.rename()', opts)
keymap('n', '<leader>ca', 'lua vim.lsp.buf.code_action()', opts)
keymap('n', 'gr', 'lua vim.lsp.buf.references()', opts)
keymap('n', 'f', 'lua vim.lsp.buf.format()', opts)
