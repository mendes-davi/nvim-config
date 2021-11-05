vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  " autocmd BufWritePost *.lua FormatWrite
augroup END
]],
	true
)

require("formatter").setup {
	logging = true,
	filetype = {
		tex = {
			function()
				return {
					exe = "latexindent",
					args = { "" },
					stdin = true,
				}
			end,
		},
		lua = {
			-- stylua
			function()
				return {
					exe = "stylua",
					args = { "--search-parent-directories", "--stdin-filepath", vim.api.nvim_buf_get_name(0), "-" },
					stdin = true,
				}
			end,
		},
		python = {
			function()
				return {
					exe = "black",
					args = { "--quiet", "--line-length 98", "-" },
					stdin = true,
				}
			end,
		},
		c = {
			function()
				return {
					exe = "clang-format",
					args = { "-assume-filename=", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), '-style="{BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 98}"' },
					stdin = true,
				}
			end,
		},
	},
}
