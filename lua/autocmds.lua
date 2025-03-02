-- Augroup {
-- 	SetupEditor = {
-- 		["FileType"] = {
-- 			{
-- 				"vhdl",
-- 				function()
-- 					vim.opt_local.foldmethod = "expr"
-- 					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 					vim.opt_local.list = true
-- 					vim.bo.expandtab = false
-- 					vim.bo.tabstop = 4
-- 					vim.bo.softtabstop = 4
-- 					vim.bo.shiftwidth = 4
-- 				end,
-- 			},
-- 			{
-- 				"ruby",
-- 				function()
-- 					vim.wo.foldmethod = "indent"
-- 					vim.wo.wrap = true

-- 					vim.bo.expandtab = false
-- 					vim.bo.tabstop = 4
-- 					vim.bo.softtabstop = 4
-- 					vim.bo.shiftwidth = 4
-- 				end,
-- 			},
-- 			{
-- 				"xtcl",
-- 				function()
-- 					vim.wo.foldmethod = "indent"
-- 					vim.wo.wrap = true

-- 					vim.bo.expandtab = false
-- 					vim.bo.tabstop = 4
-- 					vim.bo.softtabstop = 4
-- 					vim.bo.shiftwidth = 4
-- 				end,
-- 			},
-- 		},
-- 	},
-- }

Augroup {
	AutoResizeSplits = {
		{
			"VimResized",
			"*",
			function()
				vim.api.nvim_exec([[ wincmd = ]], true)
			end,
		},
	},

	LaTeX = {
		{
			"User",
			"VimtexEventQuit",
			function()
				vim.api.nvim_command "VimtexClean"
			end,
		},
		{
			"User",
			"VimtexEventCompileFailed",
			function()
				local ok, notify = pcall(require, "notify")
				if ok then
					notify("Compilation Failed!", "ERROR", {
						title = "TeX | Vimtex",
					})
				end
			end,
		},
	},

	SetupList = {
		-- Toggle list on Visual Mode
		{
			"ModeChanged",
			"*:[vV]",
			function()
				if vim.opt_local.list._value == false then
					vim.opt_local.list = true
					vim.api.nvim_create_autocmd("ModeChanged", {
						pattern = "[vV]:*",
						command = "setlocal nolist",
						once = true,
					})
				end
			end,
		},
	},
	SetupCursor = {
		-- restore-cursor
		{
			"BufReadPost",
			"*",
			function()
				-- :h restore-cursor or :h last-position-jump
				if vim.fn.line "'\"" >= 1 and vim.fn.line "'\"" <= vim.fn.line "$" and vim.bo.ft ~= "commit" then
					vim.cmd 'normal! g`"'
				end
			end,
		},
	},

	SetupTabsListFold = {
		["FileType"] = {
			{
				"qf",
				function()
					vim.bo.buflisted = false
				end,
			},
			{
				"tex",
				function()
					vim.bo.formatoptions = "jqt"
					vim.opt_local.spell = true
					vim.bo.spelllang = "en_us,pt"
				end,
			},
			{
				"python",
				function()
					vim.opt_local.foldmethod = "indent"
					vim.bo.indentexpr = "nvim_treesitter#indent()"
				end,
			},
			{
				"markdown",
				function()
					vim.opt_local.list = false
					vim.opt_local.spell = true
					vim.bo.spelllang = "en_us,pt"
				end,
			},
			{
				"vim",
				function()
					vim.wo.foldmethod = "indent"
					vim.bo.keywordprg = ":help"
				end,
			},
			--   " Gofmt formats Go programs. It uses tabs for indentation and blanks for alignment.
			--   " Alignment assumes that an editor is using a fixed-width font.
			--   " https://golang.org/cmd/gofmt/
			{
				"go",
				function()
					vim.bo.expandtab = false
					vim.bo.tabstop = 4
					vim.bo.softtabstop = 4
					vim.bo.shiftwidth = 4
				end,
			},
			{
				"vim,xml,html,yaml,dockerfile",
				function()
					vim.bo.tabstop = 2
					vim.bo.softtabstop = 2
					vim.bo.shiftwidth = 2
				end,
			},
			-- " in makefiles, don't expand tabs to spaces, since actual tab characters are
			-- " needed, and have indentation at 8 chars to be sure that all indents are tabs
			{
				"make",
				function()
					vim.bo.textwidth = 0
					vim.bo.expandtab = false
					vim.wo.wrap = false
					vim.bo.softtabstop = 0
					vim.bo.tabstop = 4
					vim.bo.shiftwidth = 4
				end,
			},
		},
	},
	MiscFileType = {
		["BufNewFile,BufRead"] = {
			{
				".gitconfig",
				function()
					vim.bo.filetype = "dosini"
				end,
			},
			{
				"*.{automount,service,socket,target,timer}",
				function()
					vim.bo.filetype = "systemd"
				end,
			},
			{
				"*.m",
				function()
					vim.bo.filetype = "matlab"
				end,
			},
			{
				"*.protoinst",
				function()
					vim.bo.filetype = "json"
				end,
			},
			{
				"*.rpt",
				function()
					vim.bo.filetype = "markdown"
				end,
			},
			{
				"*.tcl",
				function()
					vim.bo.filetype = "xtcl"
				end,
			},
		},
	},
	Misc = {
		["TextYankPost"] = {
			{
				"*",
				function()
					-- Highlight on yank
					vim.highlight.on_yank { higroup = "IncSearch", timeout = 350, on_visual = true }
				end,
			},
		},
	},
}
