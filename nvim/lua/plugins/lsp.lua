--------------------------------------------------------------------------------
--# LSP #----------------------------------------------------------------------

vim.pack.add({
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
Map('i', '<C-Space>', function()
    vim.lsp.completion.get()
end)


--# Global LSP Config #--------------------------------------------------------

-- Resolve an LSP binary through `mise` (https://mise.jdx.dev), scoped to the
-- server's root_dir. Requires the tool to be activated in-project, e.g.
-- `mise use gopls`. Errors out if it isn't.
local function mise_cmd(tool, extra_args)
    return function(dispatchers, config)
        local root_dir = config.root_dir or vim.fn.getcwd()

        local result = vim.system(
            { 'mise', 'which', tool, '-C', root_dir },
            { text = true }
        ):wait()

        if result.code ~= 0 then
            error(string.format(
                'mise: `%s` not active in %s (run `mise use %s`)\n%s',
                tool, root_dir, tool, vim.trim(result.stderr or '')
            ))
        end

        local cmd = { vim.trim(result.stdout) }
        vim.list_extend(cmd, extra_args or {})

        return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
    end
end

vim.lsp.config('*', {
    root_markers = { '.git' },
})

-- C/C++ LSP (clangd)
vim.lsp.config('clangd', {
    cmd = mise_cmd('clangd', { '--background-index' }),
    filetypes = { 'c', 'cpp' },
    root_markers = { 'Makefile', '.git' },
})
vim.lsp.enable('clangd')

-- Go LSP (gopls)
vim.lsp.config('gopls', {
    cmd = mise_cmd('gopls'),
    filetypes = { 'go' },
    root_markers = { 'go.mod', '.git' },
})
vim.lsp.enable('gopls')

-- Python LSP (pylsp)
vim.lsp.config('pylsp', {
    cmd = mise_cmd('pylsp'),
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', '.git' },
})
vim.lsp.enable('pylsp')


--# Multiline Errors #---------------------------------------------------------

require("lsp_lines").setup()
vim.diagnostic.config({ virtual_text = false, })  -- disable default lsp errors

-- toggle errors
Map('nvo', '<space><space>', require("lsp_lines").toggle)

