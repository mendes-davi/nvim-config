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
			"BufEnter,BuffRead",
			"*",
			function()
				vim.defer_fn(function()
					require("lint").try_lint()
				end, 300)
			end,
		},
	},
}
