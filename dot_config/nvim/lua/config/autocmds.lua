-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "phtml",
  callback = function()
    vim.b.autoformat = false
  end,
})
