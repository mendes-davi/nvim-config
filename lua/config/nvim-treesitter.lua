require("nvim-treesitter.configs").setup {
	ensure_installed = { "query", "c", "go", "rust", "php", "python", "lua", "json", "toml", "vue", "css", "html", "bash", "hcl" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "markdown" }, -- list of language that will be disabled
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

-- fixup nvim-treesitter cause luochen1990/rainbow not working problem
-- see https://github.com/nvim-treesitter/nvim-treesitter/issues/123#issuecomment-651162962
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/654#issuecomment-727562988
-- https://github.com/luochen1990/rainbow/issues/151#issuecomment-677644891
-- require "nvim-treesitter.highlight"
-- vim.TSHighlighter is removed, please use vim.treesitter.highlighter
-- see https://github.com/neovim/neovim/pull/14145/commits/b5401418768af496ef23b790f700a44b61ad784d
-- local hlmap = vim.treesitter.highlighter.hl_map
-- deactivate highlight of TSPunctBracket
-- highlight link TSPunctBracket Normal
-- hlmap.error = nil
-- hlmap["punctuation.delimiter"] = "Delimiter"
-- hlmap["punctuation.bracket"] = nil

-- nomad
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.hcl.filetyp_to_parsename = { "nomad", "terraform", "tf" }

parser_config.matlab = {
	install_info = {
		url = "https://github.com/mstanciu552/tree-sitter-matlab.git",
		files = { "src/parser.c" },
		branch = "main",
	},
	filetype = "matlab", -- if filetype does not agrees with parser name
}
