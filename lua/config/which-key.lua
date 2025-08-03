local which_key = require "which-key"

which_key.setup {
	delay = function(ctx)
		return ctx.plugin and 0 or 200
	end,
	notify = false,
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	icons = {
		mappings = false,
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	win = {
		border = "rounded",
		padding = { 2, 2 },
		wo = {
			winblend = 10,
		},
	},
	preset = "modern",
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
	filter = function(mapping)
		return mapping.desc and mapping.desc ~= ""
	end,
	show_help = false, -- show help message on the command line when the popup is visible
	triggers = {
		{ "<auto>", mode = "nxsot" },
		{ "<localleader>", mode = "nxsot" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local mappings_fcns = {
	dap_repl_toggle = function()
		require("dap").repl.toggle()
		vim.cmd "wincmd p"
		local filetype = vim.api.nvim_buf_get_option(0, "filetype")
		if filetype == "dap-repl" then
			vim.cmd "startinsert"
		end
	end,
}

local mappings = {
	["<leader>"] = {
		name = "Utils",
		x = { ":source %<CR>", "Source %", silent = false },
		s = { ":source ~/.config/nvim/lua/config/luasnip.lua<CR>", "Reload LuaSnips", silent = false },
	},

	-- p = {},
	-- r = {},

	d = {
		name = "Debug",
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Breakpoint" },
		c = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", "Conditional Breakpoint" },
		l = { "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", "Log Breakpoint" },
		C = { "<cmd>lua require'dap'.continue()<cr>", "Step Continue" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
		O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
		r = { mappings_fcns.dap_repl_toggle, "REPL" },
		R = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
		u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
		x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
	},

	T = {
		name = "Treesitter",
		h = { "<cmd>Inspect<CR>", "TS Highlight" },
		p = { "<cmd>InspectTree<CR>", "TS Playground" },
	},

	t = {
		name = "Tab/Terminal",
		c = { "<cmd>tabc<CR>", "Close Tab" },
		n = { "<cmd>tabe<CR>", "New Tab" },
	},

	S = {
		name = "Split",
		h = { ":set nosplitright<CR>:vnew<CR>", "Split Left" },
		l = { ":set splitright<CR>:vnew<CR>", "Split Right" },
		j = { ":set splitbelow<CR>:new<CR>", "Split Below" },
		k = { ":set nosplitbelow<CR>:new<CR>", "Split Above" },
		v = { "<C-w>v<C-w>l", "Vertical Split" },
		V = { "<cmd>vert sba<CR>", "Vertical Split Each" },
		n = { "<C-w>s", "Horizontal Split" },
	},

	o = {
		name = "Options",
		m = { "<cmd>lua MiniMap.toggle()<CR>", "MiniMap" },
		n = { "<cmd>lua vim.notify.dismiss()<CR>", "Dismiss Notifications" },
		l = { require("utils.functions").toggle_opt("wo", "list"), "List" },
		s = { require("utils.functions").toggle_opt("wo", "spell"), "Spell" },
		w = { require("utils.functions").toggle_opt("o", "wrap"), "Wrap" },
		r = { require("utils.functions").toggle_opt("o", "relativenumber"), "Relative" },
		I = { "<cmd>IndentBlanklineToggle<CR>", "Indent Blankline" },
		c = { "<cmd>lua require('treesitter-context').toggle()<CR>", "TS Context" },
		d = {
			function()
				local new_config = not vim.diagnostic.config().virtual_lines
				vim.diagnostic.config { virtual_lines = new_config }
			end,
			"Diagnostic virtual_lines",
		},
	},

	f = {
		name = "Find",
		a = { "<cmd>Telescope aerial<cr>", "Aerial Symbols" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		d = { "<cmd>Telescope frecency workspace=CWD<cr>", "Frecency" },
		s = { "<cmd>Telescope git_status<cr>", "Repo Status" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		f = {
			"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			"Find files",
		},
		g = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
		h = { "<cmd>Telescope help_tags<cr>", "Help" },
		l = { "<cmd>Telescope resume<cr>", "Last Search" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		F = { "<cmd>NvimTreeFindFile<CR>", "Find in NvimTree" },
		T = { "<cmd>TodoTrouble<CR>", "Find TODOs" },
		S = { "<cmd>SessionSelect<CR>", "Search Sessions", silent = true },
		["?"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy Find in Buffer" },
		[":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
	},

	g = {
		name = "Git",
		D = {
			name = "Diffview",
			c = { "<cmd>DiffviewClose<CR>", "Close" },
			h = { "<cmd>DiffviewFileHistory<CR>", "File History" },
			f = { "<cmd>DiffviewFocusFiles<CR>", "Focus Files" },
			o = { "<cmd>DiffviewOpen<CR>", "Open" },
			r = { "<cmd>DiffviewRefresh<CR>", "Refresh" },
			t = { "<cmd>DiffviewToggleFiles<CR>", "Toggle Files" },
		},
	},

	l = {
		name = "LSP",
		a = {
			"<cmd>lua require('telescope.builtin').lsp_code_actions({layout_strategy='cursor',layout_config={width=50, height = 10}})<cr>",
			"Code Actions",
		},
		d = {
			"<cmd>Telescope diagnostics<cr>",
			"Diagnostics",
		},
		f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		l = { require("utils.functions").toggle_diagnostics_loclist, "Loclist Diagnostics" },
		o = { "<cmd>Vista!!<cr>", "Vista Outline" },
		r = { "<cmd>Trouble lsp_references toggle<cr>", "References" },
		R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
		t = { require("utils.functions").toggle_diagnostics, "Toggle Diagnostics" },
	},

	e = { "<cmd>NvimTreeToggle<CR>", "NvimTree" },

	h = {
		function()
			local opts = {}
			local ok = pcall(require("telescope.builtin").git_files, opts)
			if not ok then
				require("telescope.builtin").find_files(opts)
			end
		end,
		"Files",
	},

	-- " Automatically fix the last misspelled word and jump back to where you were.
	-- "   Taken from this talk: https://www.youtube.com/watch?v=lwD8G1P52Sk
	s = { "<cmd>normal! mz[s1z=`z<CR>", "Fix Last Misspelled Word" },
	b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
	x = { "<cmd>Trouble diagnostics toggle<CR>", "Toggle Trouble" },

	E = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostics" },
	F = { "<cmd>lua MiniFiles.open()<cr>", "MiniFiles" },
	U = { "<cmd>MundoToggle<cr>", "Toggle Mundo" },
	X = { require("utils.functions").toggle_qf, "Toggle QF" },

	["0"] = { "<cmd>tabo<CR>", "Close All Other Tabs" },
}
which_key.register(mappings, opts)

local v_opts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local v_mappings = {
	g = { name = "Git" },
	s = { ":sort<CR>", "Sort Lines" },
}
which_key.register(v_mappings, v_opts)

local nv_mappings = {
	["n"] = { "<Plug>(miniyank-cycle)", "Miniyank Cycle" },
	["N"] = { "<Plug>(miniyank-cycleback)", "Miniyank Cycleback" },
}
which_key.register(nv_mappings, v_opts)
which_key.register(nv_mappings, opts)

local no_prefix_opts = {
	mode = "n", -- NORMAL mode
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local no_prefix_mappings = {
	["]"] = {
		d = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
	},
	["["] = {
		a = {
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			"Upwards Context",
		},
		d = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous Diagnostic" },
	},
}
which_key.register(no_prefix_mappings, no_prefix_opts)
