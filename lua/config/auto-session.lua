-- :SaveSession " saves or creates a session in the currently set `auto_session_root_dir`.
-- :SaveSession ~/my/custom/path " saves or creates a session in the specified directory path.
-- :RestoreSession " restores a previously saved session based on the `cwd`.
-- :RestoreSession ~/my/custom/path " restores a previously saved session based on the provided path.
-- :RestoreSessionFromFile ~/session/path " restores any currently saved session
-- :DeleteSession " deletes a session in the currently set `auto_session_root_dir`.
-- :DeleteSession ~/my/custom/path " deleetes a session based on the provided path.
-- :Autosession search
-- :Autosession delete
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

local opts = {
	log_level = "info",
	auto_session_enable_last_session = false,
	auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
	auto_session_enabled = true,
	auto_save_enabled = nil,
	auto_restore_enabled = nil,
	auto_session_suppress_dirs = nil,
	pre_save_cmds = { "NvimTreeClose" },
	save_extra_cmds = { "ScopeSaveState" },
	post_restore_cmds = { "ScopeLoadState" },
}

require("auto-session").setup(opts)

require("session-lens").setup {
	prompt_title = "Sessions (C-d to delete)",
	theme = "ivy",
	theme_conf = {
		winblend = nil,
		layout_config = {
			height = 0.3,
		},
	},
}
