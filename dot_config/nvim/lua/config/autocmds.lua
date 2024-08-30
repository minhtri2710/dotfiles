-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.listchars:append({ space = " " })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "php",
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.wrap = true
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.log",
	callback = function()
		vim.bo.syntax = "ON"
		vim.bo.filetype = "log"
	end,
})

-- Disable autoformat
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.phtml",
	callback = function()
		vim.b.autoformat = false
	end,
})
