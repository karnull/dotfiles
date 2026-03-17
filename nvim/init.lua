--             _             _             
--  _ ____   _(_)_ __ ___   | |_   _  __ _ 
-- | '_ \ \ / / | '_ ` _ \  | | | | |/ _` |
-- | | | \ V /| | | | | | |_| | |_| | (_| |
-- |_| |_|\_/ |_|_| |_| |_(_)_|\__,_|\__,_|
--

-- bindings
require("binds.keybinds")
require("binds.vimbinds")

if not vim.g.vscode then
    require("plugins.layout")

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.schedule(function()
                require("plugins.editor")
                require("plugins.lsp")
                require("plugins.navigate")
                require("plugins.tmux")
            end)
        end,
    })
end

