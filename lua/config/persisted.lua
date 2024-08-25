vim.o.sessionoptions = "buffers,globals,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local persisted = require "persisted"

persisted.setup {
	save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
	use_git_branch = true,
	autostart = true,
	autoload = true,
	on_autoload_no_session = function()
		vim.notify "No existing session to load :("
	end,
}

Augroup {
	Persisted = {
		{
			"User",
			"PersistedSavePre",
			function()
				vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
				pcall(vim.cmd, "ScopeSaveState")
			end,
		},
		{
			"User",
			"PersistedLoadPost",
			function()
				pcall(vim.cmd, "ScopeLoadState")
			end,
		},
	},
}
