--------------------------------------------------------------------------------
--# Layout #--------------------------------------------------------------------

vim.pack.add({
    'https://github.com/karnull/tokyoburn.nvim',    -- color theme
    'https://github.com/MunifTanjim/nui.nvim',      -- message UI framework
    'https://github.com/folke/noice.nvim',          -- message UI
    'https://github.com/airblade/vim-gitgutter',    -- git column
    'https://github.com/nvim-lualine/lualine.nvim', -- statusbar
})


--# Color Theme #---------------------------------------------------------------

require("tokyoburn").setup({
    transparent = true,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    },
    terminal_colors = true,
    lualine_bold = true,
})
vim.cmd[[colorscheme tokyoburn-night]]


--# Statusline #----------------------------------------------------------------

require('lualine').setup({
    sections = {
        lualine_x = { {
            require("noice").api.statusline.mode.get,
            cond = require("noice").api.statusline.mode.has,
            color = { fg = "#ff5f87" },
        } },
    },
})


--# Git Gutter #----------------------------------------------------------------

vim.g.gitgutter_enabled = 1       -- Enable GitGutter always
vim.o.signcolumn = 'yes'          -- Always show the sign column (gutter)


--# noice #---------------------------------------------------------------------

require("noice").setup({
    -- Keep messages on screen for longer
    views = { mini = { timeout = 10000, }, },

    lsp = {
        progress = {
            enabled = false,          -- Disable LSP progress messages
        },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },

    presets = {
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename. nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },

    routes = {{
        filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
                local client = vim.tbl_get(message.opts, "progress", "client")
                return client == "jdtls"
            end,
        },
        opts = { skip = true },
    },},

    cmdline = { format = {
        regex_down = {
            kind = "search", lang = "regex", title = " Regex Search ",
            pattern = "^/\\v", icon = " "
        },

        regex_up = {
            kind = "search", lang = "regex" , title = " Regex Search ",
            pattern = "^%?\\v", icon = " "
        },

        replace_all = {
            lang = "regex", title = " Replace All ",
            pattern = "^:%%s/", icon = "󰬲 "
        },

        replace_sel = {
            lang = "regex", title = " Replace Selected ",
            pattern = "^:'<,'>s/", icon = "󰬲 ",
        },
    } },
})

