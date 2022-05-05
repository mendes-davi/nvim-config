nnoremap { "<M-f>", "<cmd>Format<CR>" }

require("formatter").setup {
	logging = true,
	filetype = {
		matlab = {
			function()
				return {
					exe = "mh_style",
					args = { "--fix", "--brief", vim.api.nvim_buf_get_name(0) },
					stdin = false,
					cwd = vim.fn.expand "%:p:h",
					ignore_exitcode = true,
				}
			end,
		},
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
