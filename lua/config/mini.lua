local map = require "mini.map"

map.setup {
	integrations = {
		map.gen_integration.diagnostic(),
		map.gen_integration.gitsigns {
			add = "GitSignsAdd",
			change = "GitSignsChange",
			delete = "GitSignsDelete",
		},
	},
	symbols = {
		encode = map.gen_encode_symbols.dot "4x2",
	},
	window = {
		show_integration_count = false,
		winblend = 0,
		width = 7,
	},
}

Augroup {
	MiniMapHighlight = {
		{
			"Colorscheme",
			"*",
			function()
				local curr_hi = vim.api.nvim_get_hl_by_name("MiniMapNormal", true)
				local new_hi = vim.tbl_extend("force", {}, curr_hi, { bg = "None" })
				vim.api.nvim_set_hl(0, "MiniMapNormal", new_hi)
			end,
		},
	},
	MiniMapAutoOpen = {
		{
			"BufReadPost",
			"*",
			function()
				if vim.fn.line "'\"" >= 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
					pcall(MiniMap.open)
				end
			end,
		},
	},
}
