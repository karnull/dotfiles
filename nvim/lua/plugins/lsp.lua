--------------------------------------------------------------------------------
--# LSP #----------------------------------------------------------------------

vim.pack.add({
    'https://github.com/williamboman/mason.nvim',
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
})


--# Completion #---------------------------------------------------------------

vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

-- Enable LSP-driven autocompletion on attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.completion', {}),

    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true,
            })
        end
    end,
})

-- Use CTRL-space to manually trigger LSP completion
vim.keymap.set('i', '<C-Space>', function()
    vim.lsp.completion.get()
end)


--# Global LSP Config #--------------------------------------------------------

vim.lsp.config('*', {
    root_markers = { '.git' },
})

-- C/C++ LSP (clangd)
vim.lsp.config('clangd', {
    cmd = { 'clangd', '--background-index' },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'Makefile', '.git' },
})
vim.lsp.enable('clangd')

-- Go LSP (gopls)
vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    filetypes = { 'go' },
    root_markers = { 'go.mod', '.git' },
})
vim.lsp.enable('gopls')

-- Python LSP (pylsp)
vim.lsp.config('pylsp', {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', '.git' },
})
vim.lsp.enable('pylsp')


require('mason').setup()


--# Multiline Errors #---------------------------------------------------------

require("lsp_lines").setup()
vim.diagnostic.config({ virtual_text = false, })  -- disable default lsp errors

-- toggle errors
vim.keymap.set(
    "", "<space><space>", require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
)

