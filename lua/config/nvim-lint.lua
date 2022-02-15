require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	matlab = { "mlint" },
}

Augroup {
	NvimLint = {
		{
			"BufWritePost",
			"*",
			function()
				require("lint").try_lint()
			end,
		},
		{
			"BufEnter",
			"*",
			function()
				require("lint").try_lint()
			end,
		},
	},
}
