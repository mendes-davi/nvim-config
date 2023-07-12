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
		encode = map.gen_encode_symbols.dot "3x2",
	},
	window = {
		show_integration_count = false,
		winblend = 00,
	},
}

Augroup {
	MiniMapHighlight = {
		{
			"Colorscheme",
			"*",
			function()
				vim.api.nvim_set_hl(0, "MiniMapNormal", { bg = "NONE" })
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
