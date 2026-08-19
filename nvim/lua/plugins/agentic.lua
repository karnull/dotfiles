--------------------------------------------------------------------------------
--# Claude Code #-----------------------------------------------------------------

vim.pack.add({
    'https://github.com/coder/claudecode.nvim', -- claude code companion
})

--# Setup #-----------------------------------------------------------------------

require('claudecode').setup({
    terminal = {
        split_side = 'right',
        split_width_percentage = 0.30,
        provider = 'native',
    },
})


--# Keybinds #--------------------------------------------------------------------

Map('n', '<leader>jj', ':ClaudeCode<CR>')             -- toggle claude
Map('n', '<leader>jf', ':ClaudeCodeFocus<CR>')        -- focus claude window
Map('n', '<leader>jr', ':ClaudeCode --resume<CR>')    -- resume last session
Map('n', '<leader>jc', ':ClaudeCode --continue<CR>')  -- continue conversation
Map('n', '<leader>jb', ':ClaudeCodeAdd %<CR>')        -- add current buffer

Map('v', '<leader>js', ':ClaudeCodeSend<CR>')         -- send selection

Map('n', '<leader>ja', ':ClaudeCodeDiffAccept<CR>')   -- accept diff
Map('n', '<leader>jd', ':ClaudeCodeDiffDeny<CR>')     -- deny diff
