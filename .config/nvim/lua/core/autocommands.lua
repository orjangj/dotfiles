-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua', 'cmake'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

augroup('norgConceal', { clear = true })
autocmd('Filetype', {
  group = 'norgConceal',
  pattern = { 'norg' },
  command = 'setlocal conceallevel=2 foldlevel=1'
})
