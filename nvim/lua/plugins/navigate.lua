-------------------------------------------------------------------------------
--# Navigate #-----------------------------------------------------------------

vim.pack.add({
    'https://github.com/nvim-telescope/telescope.nvim',  -- 
    'https://github.com/nvim-lua/plenary.nvim',          -- 
})

--# Telescope #----------------------------------------------------------------

local telescope = require('telescope')

telescope.setup{
	defaults = {
		layout_config = {
			horizontal = {
				preview_width = 0.55,
				results_width = 0.45,
			},
			vertical = {
				preview_height = 0.6,
			},
			width = 0.8,
			height = 0.8,
		},
		layout_strategy = 'horizontal',
		selection_caret = "▶ ",
        prompt_prefix = " ",

	},
}

local builtin = require('telescope.builtin')

Map('n', '<leader>z', builtin.git_files)
Map('n', '<leader>x', builtin.buffers)
Map('n', '<leader>c', builtin.find_files)
Map('n', '<leader>m', builtin.marks)

Map('n', '<leader>n', ':Telescope noice<CR>')
Map('n', '<leader>g', builtin.live_grep)
Map('n', '<leader>v', builtin.registers)
Map('n', '<leader>k', builtin.keymaps)

