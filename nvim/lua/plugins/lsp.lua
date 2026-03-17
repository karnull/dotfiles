--------------------------------------------------------------------------------
--# LSP #-----------------------------------------------------------------------

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',          -- server defaults
    'https://github.com/nvim-treesitter/nvim-treesitter',-- parser installer
})


--# LSP Config #----------------------------------------------------------------

--# Completion #--

-- 'autocomplete' (binds/vimbinds.lua) feeds off 'complete', whose "o" flag is
-- the LSP-owned 'omnifunc' -- listed first, so servers lead the menu.
vim.opt.complete = { 'o', '.^10', 'w^5', 'b^5', 'u^5', 't^5' }
vim.opt.completeopt = { 'menuone', 'noselect', 'popup', 'nearest' }

-- Candidates already arrive via 'omnifunc'; `completion.enable()` is what
-- makes *accepting* one with <C-y> apply the server's side effects -- snippet
-- expansion, extra text edits such as auto-imports -- and what fills the
-- 'popup' preview from "completionItem/resolve".
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.completion', {}),

    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf)
        end
    end,
})

-- manually trigger LSP completion, CTRL-y to accept
Map('i', '<leader><space>', function()
    vim.lsp.completion.get()
end)


--# Servers #--

vim.lsp.config('clangd', {
    root_markers = {
        { 'compile_commands.json', '.clangd' },
        'Makefile',
        '.git',
    },
})

vim.lsp.enable({
    'clangd',
    'gopls',
    'pylsp',
})


--# Diagnostics #--

-- `virtual_lines` is built in as of 0.11 and replaces lsp_lines.nvim.
vim.diagnostic.config({
    virtual_lines = true,
    virtual_text = false,
    severity_sort = true,
})

-- toggle multiline errors
Map('nvo', '<space><space>', function()
    vim.diagnostic.config({
        virtual_lines = not vim.diagnostic.config().virtual_lines,
    })
end)


--# Treesitter #----------------------------------------------------------------

-- Nvim has the highlighter but no installer, and bundles parsers only for c,
-- lua, markdown, vim, vimdoc and query -- so just three are left to fetch.
-- Wants `brew install tree-sitter-cli` (`tree-sitter` is the library alone).
local parsers = { 'bash', 'go', 'zsh' }
local filetypes = { 'bash', 'c', 'go', 'lua', 'markdown', 'sh', 'zsh' }

-- without the CLI every parser fails, once per parser, on every startup
if vim.fn.executable('tree-sitter') == 1 then
    require('nvim-treesitter').install(parsers)
else
    vim.notify('treesitter: no `tree-sitter` CLI on PATH', vim.log.levels.WARN)
end

-- `sh` is the one filetype not named after its parser
vim.treesitter.language.register('bash', { 'sh' })

local function start(buf)
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)

    if lang and vim.treesitter.language.add(lang) then
        vim.treesitter.start(buf, lang)
    end
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('my.treesitter', {}),
    pattern = filetypes,

    callback = function(ev)
        start(ev.buf)
    end,
})

-- init.lua requires this on VimEnter, after the first FileType has fired
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf)
        and vim.list_contains(filetypes, vim.bo[buf].filetype)
    then
        start(buf)
    end
end

-- Neither conf nor tmux has a parser, so .conf stays on regex syntax -- but
-- the fragments tmux.conf sources type as `conf`, missing nvim's tmux syntax.
vim.filetype.add({
    pattern = { ['.*/tmux/.*%.conf'] = 'tmux' },
})
