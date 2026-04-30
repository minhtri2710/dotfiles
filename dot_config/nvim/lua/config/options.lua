vim.g.mapleader = " "

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf8,latin1"

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.listchars:append({ space = "•" })
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

vim.opt.shell = "fish"
if vim.fn.has("win32") == 1 then
	-- Detect the configured shell name (tail of the path) and normalize to lowercase
	local shell = vim.o.shell or ""
	local shname = shell:lower():match("([^/\\]+)$") or shell:lower()

	if shname:match("nu") then
		-- nushell
		vim.opt.shellcmdflag = "-c"
		vim.opt.shellxquote = ""
	elseif shname:match("pwsh") or shname:match("powershell") then
		-- PowerShell / pwsh
		vim.opt.shellcmdflag =
			"-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
		vim.opt.shellredir = ""
		vim.opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
		vim.opt.shellquote = ""
		vim.opt.shellxquote = ""
	else
		-- Fallback for other shells (cmd, bash, etc.)
		vim.opt.shellcmdflag = "-c"
		vim.opt.shellxquote = ""
	end
end

-- Change lsp php in lazyvim
vim.g.lazyvim_php_lsp = "intelephense"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

-- Change lsp typescript
vim.g.lazyvim_ts_lsp = "tsgo"
