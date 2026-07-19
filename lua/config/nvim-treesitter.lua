local ts = require "nvim-treesitter"

ts.setup {
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = function(lang, buf)
			local disabled_langs = { "latex", "matlab" }
			if vim.tbl_contains(disabled_langs, lang) then
				return true
			end

			local max_filesize = 250 * 1024 -- 250 KB
			local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
	},
	query_linter = {
		enable = false,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
	rainbow = {
		enable = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	textobjects = {
		select = {
			enable = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
				["]o"] = "@loop.*",
				["]l"] = { query = "@scope", query_group = "locals" },
				["]z"] = { query = "@fold", query_group = "folds" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
			goto_next = {
				["]i"] = "@conditional.outer",
			},
			goto_previous = {
				["[i"] = "@conditional.outer",
			},
		},
		lsp_interop = {
			enable = true,
			border = "none",
			peek_definition_code = {
				["df"] = "@function.outer",
				["dF"] = "@class.outer",
			},
		},
	},
}

ts.install {
	"bash",
	"c",
	"cpp",
	"css",
	"go",
	"hcl",
	"vimdoc",
	"html",
	"json",
	"latex",
	"lua",
	"markdown",
	"markdown_inline",
	"php",
	"python",
	"query",
	"rust",
	"ruby",
	"toml",
	"verilog",
	"vim",
	"vue",
	"matlab",
	"vhdl",
}
