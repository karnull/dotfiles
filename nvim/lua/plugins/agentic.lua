--------------------------------------------------------------------------------
--# Agentic #-------------------------------------------------------------------

vim.pack.add({
	'https://github.com/github/copilot.vim',
})

local started = false

vim.keymap.set("n", "<leader><leader>c", function()
	if not started then
		started = true
		vim.notify("Starting Copilot", vim.log.levels.INFO)
		vim.cmd("Copilot setup")
		vim.cmd("Copilot enable")
	else
		vim.notify("Copilot's already running", vim.log.levels.INFO)
	end
end, { desc = "Start Copilot" })

vim.keymap.set("n", "<leader><leader>C", function()
	vim.notify("Disabling Copilot", vim.log.levels.INFO)
	vim.cmd("Copilot disable")
	started = false
end, { desc = "Disable Copilot" })
