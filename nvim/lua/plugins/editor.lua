--------------------------------------------------------------------------------
--# Editor #--------------------------------------------------------------------

vim.pack.add({
    'https://github.com/tpope/vim-obsession',         --
    'https://github.com/numToStr/Comment.nvim',       -- easier commenting
    'https://github.com/kylechui/nvim-surround',      -- more surround actions
    'https://github.com/karshPrime/ifdef.nvim',       --
    'https://github.com/folke/twilight.nvim',         -- dim non-focused code
    'https://github.com/Djancyp/better-comments.nvim',-- colour coded comments
    'https://github.com/lukas-reineke/indent-blankline.nvim'
})


--# Enable Plugins #------------------------------------------------------------

require('Comment').setup()        -- Better Commenting
require("nvim-surround").setup()  -- Surround Actions
require('ifdef').setup()          -- Surrounding #defines


--# Keybinds #------------------------------------------------------------------

Map('ni', '<leader>h',  ':Ifdef current<CR>') -- surrounding defines
Map('n', '<leader>u',  ':UndotreeToggle<CR>') -- undo tree


--# Better Comments #-----------------------------------------------------------

require('better-comment').Setup({
    tags = {{
        name = "TODO",
        fg = "white",
        bg = "#0a7aca",
        bold = true,
        virtual_text = "",
    },{
        name = "FIX",
        fg = "white",
        bg = "#f44747",
        bold = true,
        virtual_text = "",
    },{
        name = "WARNING",
        fg = "#FFA500",
        bg = "",
        bold = false,
        virtual_text = "",
    },{
        name = "!",
        fg = "#f44747",
        bg = "",
        bold = true,
        virtual_text = "",
    }}
})


--# Twilight #------------------------------------------------------------------

require('twilight').setup({
    treesitter = true,
    context = 1,
    expand = {
        "function_declaration",
        "method_declaration",
        "method_signature",
        "ambient_declaration",
    },
    exclude = { 'md' }
})


--# Indent Blankline #----------------------------------------------------------

local hooks = require("ibl.hooks")

-- Define your highlight groups
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "IndentDark", { fg = "#2f4f4f" })
    vim.api.nvim_set_hl(0, "IndentStrong", { fg = "#ff5f87" })
end)

-- Setup indent-blankline
require("ibl").setup {
    indent = {
        highlight = {
            "IndentDark",
            "IndentDark",
            "IndentDark",
            "IndentDark",
            "IndentDark",
            "IndentDark",
            "IndentStrong",
        },
    },
    scope = {
        enabled = true,
        highlight = "IndentStrong",
    },
}

