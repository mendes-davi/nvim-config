local map = require "mini.map"
local files = require "mini.files"

files.setup {}

if vim.fn.has "win32" == 1 then
	nnoremap { "<A-o>", "<cmd>lua MiniFiles.open()<cr>" }
end

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
	MiniFilesKeymaps = {
		{
			"User",
			"MiniFilesBufferCreate",
			function(args)
				nnoremap { "<A-o>", "<cmd>lua MiniFiles.close()<cr>", "Close MiniFiles", buffer = args.data.buf_id }
			end,
		},
	},
	MiniMapHighlight = {
		{
			"UIEnter",
			"*",
			function()
				local curr_hi = vim.api.nvim_get_hl(0, { name = "MiniMapNormal", link = false })
				local new_hi = vim.tbl_extend("force", {}, curr_hi, { bg = "None" })
				vim.api.nvim_set_hl(0, "MiniMapNormal", new_hi)
			end,
		},
	},
}
