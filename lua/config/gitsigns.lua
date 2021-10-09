require("gitsigns").setup {
	signs = {
		add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
		change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
		delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr" },
		topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
		changedelete = { hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr" },
	},
	numhl = false,
	sign_priority = 6,
	keymaps = {
		noremap = true,
		buffer = true,
		["n <leader>hn"] = '<cmd>lua require("gitsigns").next_hunk()<CR>',
		["n <leader>hp"] = '<cmd>lua require("gitsigns").prev_hunk()<CR>',
		["n <leader>hs"] = '<cmd>lua require("gitsigns").stage_hunk()<CR>',
		["n <leader>hu"] = '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>',
		["n <leader>hr"] = '<cmd>lua require("gitsigns").reset_hunk()<CR>',
		["n <leader>hb"] = '<cmd>lua require("gitsigns").blame_line()<CR>',
		["n <leader>hR"] = '<cmd>lua require("gitsigns").reset_buffer()<CR>',
		["n <leader>hP"] = '<cmd>lua require("gitsigns").preview_hunk()<CR>',
	},
	watch_index = {
		interval = 1000,
	},
	current_line_blame = false,
	update_debounce = 500,
	diff_opts = { internal = true },
	status_formatter = nil, -- Use default
}
