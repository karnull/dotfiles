-------------------------------------------------------------------------------
--# Additions #----------------------------------------------------------------

-- window & split behavior
vim.o.splitright = true     -- open vertical splits to the right
vim.o.splitbelow = true     -- open horizontal splits below
vim.o.scrolloff = 5         -- keep 5 lines visible above/below cursor

-- display & visual
vim.o.number = true         -- show line numbers
vim.o.relativenumber = true -- show relative line numbers
vim.o.cursorline = true     -- highlight the current line
vim.o.termguicolors = true  -- enable 24-bit RGB colors
vim.o.linebreak = true      -- wrap long lines at word boundaries
vim.o.textwidth = 80        -- wrap text at column 80
vim.o.laststatus = 3        -- always show a single global statusline
vim.o.visualbell = true     -- use visual bell instead of beeping
vim.o.showmatch = true      -- briefly jump to matching bracket
vim.cmd('syntax enable')    -- enable syntax highlighting

-- search behavior
vim.o.hlsearch = true       -- highlight all search matches
vim.o.incsearch = true      -- show search matches as you type
vim.o.ignorecase = true     -- case-insensitive search by default
vim.o.smartcase = true      -- case-sensitive search when query has uppercase

-- indentation & tabs
vim.o.autoindent = true     -- copy indent from current line on newline
vim.o.smartindent = true    -- smart auto-indenting for new lines
vim.o.breakindent = true    -- preserve indent on wrapped lines
vim.o.tabstop = 4           -- how wide a tab *displays*
vim.o.shiftwidth = 4        -- how much >>, << indent by
vim.o.softtabstop = 0       -- disable "soft tab" fakery, let tabstop govern
vim.o.expandtab = false     -- pressing <Tab> inserts a real tab char
vim.opt.smarttab = true     -- Tab at line start uses shiftwidth/tabstop sensibly

-- completion
vim.o.autocomplete = true   -- enable built-in autocompletion
vim.o.pumheight = 10        -- popup menu height (or pumwidth = 40 for width)

-- editor defaults
vim.o.compatible = false    -- disable vi-compatible mode, use nvim defaults
vim.o.undolevels = 1000     -- maximum undo levels
vim.opt.grepprg = "rg --vimgrep"  -- use ripgrep for :grep
vim.opt.shortmess:append("I")     -- suppress the intro message on startup
vim.opt.guioptions:remove('e')    -- disable GUI tab pages line
vim.o.backspace = "indent,eol,start"         -- allow backspace over everything

-- visual noise
vim.opt.list = true
vim.opt.listchars = { tab = "▏ ", trail = "░", nbsp = "░" }

-- file explorer (netrw)
vim.g.netrw_banner = 0
vim.g.netrw_sort_options = "i"
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"

-- load after loading the editor
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.schedule(function()
            vim.o.clipboard = "unnamedplus"
            vim.cmd('set rtp+=/opt/homebrew/opt/fzf')
        end)
    end,
})
