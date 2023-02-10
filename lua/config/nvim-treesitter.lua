require("nvim-treesitter.configs").setup {
	ensure_installed = { "query", "c", "cpp", "go", "rust", "php", "python", "lua", "json", "toml", "vue", "css", "html", "bash", "hcl", "latex" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "markdown", "latex" }, -- list of language that will be disabled
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
	context_commentstring = {
		enable = true,
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
	},
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = "@class.outer",
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
	},
	lsp_interop = {
		enable = true,
		border = "none",
		peek_definition_code = {
			["df"] = "@function.outer",
			["dF"] = "@class.outer",
		},
	},
}

-- MATLAB
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.matlab = {
	install_info = {
		url = "https://github.com/mstanciu552/tree-sitter-matlab.git",
		files = { "src/parser.c" },
		branch = "main",
	},
	filetype = "matlab", -- if filetype does not agrees with parser name
}
