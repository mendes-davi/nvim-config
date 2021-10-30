local efm = "%-P========== %f ==========,%-G%>========== %s ==========,%-G%>L %l (C %c): MDOTM%m,L %l (C %c): %m,L %l (C %c-%*[0-9]): %m,%-Q"

require("lint").linters.mlint = {
	cmd = "mlint",
	stdin = false,
	stream = "stderr",
	args = { "-cyc", "-id", "-severity" },
	ignore_exitcode = true,
	parser = require("lint.parser").from_errorformat(efm, { source = "mlint", severity = vim.lsp.protocol.DiagnosticSeverity.Information }),
}

require("lint").linters_by_ft = {
	markdown = { "vale" },
	sh = { "shellcheck" },
	matlab = { "mlint" },
}

Augroup {
	NvimLint = {
		{
			"BufWritePost",
			"<buffer>",
			function()
				require("lint").try_lint()
			end,
		},
		{
			"BufEnter",
			"<buffer>",
			function()
				require("lint").try_lint()
			end,
		},
	},
}
