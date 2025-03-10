-- This file can be loaded by calling `lua require('plugins')` from your init.vim

require "utils"

vim.loader.enable()

return require("lazy").setup {

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				main = "ts_context_commentstring",
				opts = { enable_autocmd = false },
			},
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		config = function()
			require "config.nvim-treesitter"
		end,
	},

	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup {
				hooks = {
					pre_tab_leave = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
					end,

					post_tab_enter = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
					end,
				},
			}
		end,
	},

	{
		"lervag/vimtex",
		ft = { "tex", "latex", "bib" },
		init = function()
			local viewer = "zathura"
			if vim.fn.has "mac" == 1 then
				viewer = "skim"
			end
			Variable.g {
				vimtex_quickfix_mode = 0,
				vimtex_view_method = viewer,
				vimtex_compiler_latexmk = {
					options = {
						"-pdf",
						"-shell-escape",
						"-verbose",
						"-file-line-error",
						"-synctex=1",
						"-interaction=nonstopmode",
					},
				},
			}
		end,
		opts = {},
	},

	{
		"nvim-tree/nvim-web-devicons",
		opts = {
			override = {
				tcl = {
					icon = "",
					color = "#1e5cb3",
					cterm_color = "25",
					name = "Tcl",
				},
			},
		},
	},

	{
		"romgrk/barbar.nvim",
		config = function()
			require "config.barbar"
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			map { "<F4>", "<cmd> NvimTreeToggle<CR>", "NvimTree" }
		end,
		config = function()
			require "config.nvim-tree"
		end,
	},

	{
		lazy = true,
		"nvim-neotest/neotest",
		dependencies = {
			"olimorris/neotest-rspec",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup {
				adapters = {
					require "neotest-rspec" {
						rspec_cmd = function()
							return vim.tbl_flatten {
								"bundle",
								"exec",
								"rspec",
							}
						end,
					},
				},
			}
		end,
		init = function()
			Augroup {
				NeotestConfig = {
					{
						"FileType",
						"neotest-output*",
						function(opts)
							vim.keymap.set("n", "q", function()
								pcall(vim.api.nvim_win_close, 0, true)
							end, {
								buffer = opts.buf,
							})
						end,
					},
				},
			}
		end,
	},

	{
		"stevearc/aerial.nvim",
		init = function()
			nnoremap { "<F3>", "<cmd> AerialToggle<CR>", "Aerial Outline" }
		end,
		opts = {
			attach_mode = "global",
			backends = {
				["_"] = { "lsp", "treesitter", "markdown", "man" },
				vhdl = { "treesitter" },
				ruby = { "treesitter" },
			},
			show_guides = true,
			layout = {
				resize_to_content = false,
				win_opts = {
					winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
					signcolumn = "yes",
					statuscolumn = " ",
				},
			},
			filter_kind = false,
			guides = {
				mid_item = "├╴",
				last_item = "└╴",
				nested_top = "│ ",
				whitespace = "  ",
			},
		},
	},

	{
		"simeji/winresizer",
		keys = "<C-e>",
		init = function()
			Variable.g {
				winresizer_start_key = "<C-e>",
			}
		end,
	},

	{
		"junegunn/vim-easy-align",
		init = function()
			-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
			nmap { "ga", "<Plug>(EasyAlign)" }
			-- Start interactive EasyAlign in visual mode (e.g. vipga)
			xmap { "ga", "<Plug>(EasyAlign)" }
		end,
	},

	-- https://simnalamburt.github.io/vim-mundo/#configuration
	{
		"simnalamburt/vim-mundo",
		init = function()
			nnoremap { "<F9>", "<cmd> MundoToggle<CR>", "Toggle Mundo" }
			require "config.vim-mundo"
		end,
	},

	{
		"folke/which-key.nvim",
		config = function()
			require "config.which-key"
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "rcarriga/nvim-notify", "p00f/clangd_extensions.nvim", "ray-x/lsp_signature.nvim" },
		event = "User FilePost",
		config = function()
			require "config.nvim-lspconfig"
		end,
	},

	-- A pretty diagnostics list to help you solve all the trouble your code is causing.
	-- https://github.com/folke/lsp-trouble.nvim
	{
		"folke/lsp-trouble.nvim",
		cmd = "Trouble",
		config = function()
			require "config.lsp-trouble"
		end,
	},

	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoLocList", "TodoTelescope", "TodoQuickFix" },
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {}
		end,
	},

	-- notification
	{
		"rcarriga/nvim-notify",
		opts = {
			animate = false,
			stages = "static",
			-- For stages that change opacity this is treated as the highlight behind the window
			-- Set this to either a highlight group or an RGB hex value e.g. "#000000"
			background_colour = function()
				local group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Normal"), "bg#")
				if group_bg == "" or group_bg == "none" then
					group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Float"), "bg#")
					if group_bg == "" or group_bg == "none" then
						return "#000000"
					end
				end
				return group_bg
			end,
		},
		config = function(_, opts)
			local notify = require "notify"
			notify.setup(opts)
			vim.notify = notify
		end,
	},

	"chrisbra/NrrwRgn",

	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		config = function()
			require "config.luasnip"
		end,
	},

	{
		"ms-jpq/coq_nvim",
		branch = "coq",
		dependencies = {
			{
				"windwp/nvim-autopairs",
				opts = {
					disable_filetype = { "TelescopePrompt", "vim" },
				},
			},
		},
		event = "InsertEnter",
		init = function()
			Variable.g {
				coq_settings = {
					display = { icons = { mappings = require("lsp").icons } },
					keymap = {
						recommended = false,
						jump_to_mark = "",
						bigger_preview = "",
						manual_complete = "<A-Space>",
					},
					auto_start = "shut-up",
					clients = {
						tabnine = { enabled = false },
						snippets = { enabled = false },
					},
				},
			}
		end,
		config = function()
			require "config.coq"
		end,
	},

	{
		"ms-jpq/coq.thirdparty",
		event = "InsertEnter",
		dependencies = { "ms-jpq/coq_nvim" },
		branch = "3p",
		config = function()
			require "config.coq_3p"
		end,
	},

	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = { "theHamsta/nvim-dap-virtual-text" },
		config = function()
			require "config.nvim-dap"
		end,
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		config = function()
			require("nvim-dap-virtual-text").setup {
				enabled = true, -- enable this plugin (the default)
				enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
				highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				show_stop_reason = true, -- show stop reason when stopped for exceptions
				commented = false, -- prefix virtual text with comment string
				-- experimental features:
				virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
				all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
				virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
				virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
				-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
			}
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		lazy = true,
		config = function()
			require("dapui").setup {
				layouts = {
					{
						elements = {
							"scopes",
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 10,
						position = "bottom",
					},
				},
			}
		end,
	},

	{
		"echasnovski/mini.nvim",
		branch = "main",
		config = function()
			require "config.mini"
		end,
	},

	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require "config.statuscol"
		end,
	},

	-- " https://github.com/kevinhwang91/nvim-bqf
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup {
				preview = {
					border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
					winblend = 0,
				},
			}
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			"nvim-telescope/telescope-frecency.nvim",
		},
		cmd = "Telescope",
		config = function()
			require "config.telescope"
		end,
	},

	{
		"numtostr/FTerm.nvim",
		config = function()
			require "config.fterm"
		end,
	},

	{
		"luochen1990/rainbow",
		event = "User FilePost",
		init = function()
			Variable.g {
				rainbow_active = 1,
			}
		end,
	},

	{
		"johnfrankmorgan/whitespace.nvim",
		event = "User FilePost",
		main = "whitespace-nvim",
		opts = {
			highlight = "DiffDelete",
			ignored_filetypes = { "TelescopePrompt", "Trouble", "help" },
			ignore_terminal = true,
		},
		init = function()
			nmap { "<Leader><Leader>t", require("whitespace-nvim").trim, "Trim Whitespace" }
		end,
	},

	{
		"freddiehaddad/feline.nvim",
		config = function()
			require "config.feline"
		end,
	},

	{
		"mhartington/formatter.nvim",
		cmd = "Format",
		opts = require("config.formatter").opts,
		init = function()
			nnoremap { "<A-f>", "<cmd> Format<CR>" }
		end,
	},

	"tpope/vim-surround",
	"tpope/vim-repeat",
	-- use "tpope/vim-unimpaired"

	{
		"numToStr/Comment.nvim",
		lazy = true,
		config = function()
			require("Comment").setup {
				-- ignore empty lines for comments
				ignore = "^$",

				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
		end,
		init = function()
			nmap { "<A-/>", "<cmd> lua require('Comment.api').toggle.linewise.current()<CR>" }
			vmap { "<A-/>", "<esc><cmd> lockmarks lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>" }
			imap { "<A-/>", "<cmd> lua require('Comment.api').toggle.linewise.current()<CR>" }
		end,
	},

	"wellle/targets.vim",

	{
		"mg979/vim-visual-multi",
		keys = "<C-n>",
		branch = "master",
	},

	{
		"mfussenegger/nvim-lint",
		ft = { "matlab", "sh" },
		config = function()
			nnoremap { "gl", "<cmd> lua require('lint').try_lint()<CR>", "Lint" }
			require "config.nvim-lint"
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "User FilePost",
		opts = require("config.gitsigns").opts,
		init = require("config.gitsigns").init,
	},

	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewClose",
			"DiffviewFileHistory",
			"DiffviewFocusFiles",
			"DiffviewOpen",
			"DiffviewRefresh",
			"DiffviewToggleFiles",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"rrethy/vim-illuminate",
		event = "User FilePost",
		opts = require("config.illuminate").opts,
		config = function(_, opts)
			require("illuminate").configure(opts)
			require("config.illuminate").map_keys()
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = { "ZenMode" },
		init = function()
			nnoremap { "<A-d>", "<cmd> ZenMode<CR>" }
		end,
		opts = {
			plugins = { tmux = { enabled = true }, alacritty = { enabled = true, font = "13" } },
		},
	},

	{
		"numToStr/Navigator.nvim",
		lazy = true,
		opts = {
			auto_save = "current",
			disable_on_zoom = false,
		},
		init = function()
			nnoremap { "<A-h>", "<cmd> lua require('Navigator').left()<CR>" }
			nnoremap { "<A-k>", "<cmd> lua require('Navigator').up()<CR>" }
			nnoremap { "<A-l>", "<cmd> lua require('Navigator').right()<CR>" }
			nnoremap { "<A-j>", "<cmd> lua require('Navigator').down()<CR>" }
			nnoremap { "<A-\\>", "<cmd> lua require('Navigator').previous()<CR>" }
		end,
	},

	{
		"bfredl/nvim-miniyank",
		init = function()
			require "config.nvim-miniyank"
		end,
	},

	{
		"olimorris/persisted.nvim",
		lazy = false,
		opts = {
			save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
			use_git_branch = true,
			autostart = true,
			autoload = true,
			on_autoload_no_session = function()
				vim.notify "No existing session to load :("
			end,
		},
		init = function()
			Augroup {
				Persisted = {
					{
						"User",
						"PersistedSavePre",
						function()
							vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
							pcall(vim.cmd, "ScopeSaveState")
						end,
					},
					{
						"User",
						"PersistedLoadPost",
						function()
							pcall(vim.cmd, "ScopeLoadState")
						end,
					},
				},
			}
		end,
	},

	{
		"kevinhwang91/rnvimr",
		enabled = (vim.fn.has "win32" == 0),
		cmd = { "RnvimrToggle", "RnvimrResize", "RnvimrStartBackground" },
		init = function()
			nnoremap { "<A-o>", "<cmd> RnvimrToggle<CR>" }
			tnoremap { "<A-o>", "<cmd> RnvimrToggle<CR>" }

			Variable.g {
				rnvimr_ranger_cmd = { require("utils.python").get_ranger_cmd(), "--cmd=set draw_borders both" },
				rnvimr_enable_ex = 1,
				rnvimr_enable_picker = 1,
				-- <C-t> tab
				-- <C-x> split
				-- <C-v> vsplit
				-- gw cd
				-- yw pwd
			}
		end,
	},

	{
		"justinmk/vim-gtfo",
		-- enabled = (vim.fn.has "win32" == 1),
		init = function()
			vim.cmd [[let g:gtfo#terminals = { 'win': 'cmd.exe /k', 'unix': 'setsid -f alacritty --working-directory ' }]]
		end,
	},

	{
		"t-troebst/perfanno.nvim",
		cmd = {
			"PerfAnnotate",
			"PerfAnnotateFunction",
			"PerfAnnotateSelection",
			"PerfCycleFormat",
			"PerfHottestLines",
			"PerfHottestLinesFunction",
			"PerfHottestLinesSelection",
			"PerfHottestSymbols",
			"PerfLoadCallGraph",
			"PerfLoadFlameGraph",
			"PerfLoadFlat",
			"PerfLuaProfileStart",
			"PerfLuaProfileStop",
			"PerfPickEvent",
			"PerfToggleAnnotations",
		},
		config = function()
			local perfanno = require "perfanno"
			local util = require "perfanno.util"
			perfanno.setup { -- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300" line_highlights = util.make_bg_highlights("#37343A", "#CC3300", 4),
				vt_highlight = util.make_fg_highlight "#CC3300",
			}
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User FilePost",
		main = "ibl",
		opts = {
			indent = {
				char = "▏",
			},
			scope = {
				show_start = false,
				show_end = false,
			},
		},
		config = function(_, opts)
			local hooks = require "ibl.hooks"
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
			require("ibl").setup(opts)
		end,
	},

	{
		"sainnhe/sonokai",
		-- lazy = true,
		priority = 1000,
		init = function()
			vim.go.background = "dark"
			Variable.g {
				sonokai_better_performance = 1,
				sonokai_disable_terminal_colors = 1,
				sonokai_style = "maia",
				sonokai_enable_italic = 1,
				sonokai_diagnostic_virtual_text = "colored",
				sonokai_disable_italic_comment = 0,
				sonokai_transparent_background = 1,
				sonokai_diagnostic_text_highlight = 0,
				sonokai_inlay_hints_background = "none",
				-- sonokai_current_word = "underline",
			}

			if vim.g.neovide then
				Variable.g {
					sonokai_transparent_background = 0,
				}
			end
		end,
		config = function()
			vim.cmd [[ silent! colorscheme sonokai ]]
			vim.cmd [[ hi PmenuSel blend=0 ]]
		end,
	},

	{
		"sainnhe/everforest",
		lazy = true,
		init = function()
			vim.go.background = "dark"
			Variable.g {
				everforest_better_performance = 1,
				everforest_disable_terminal_colors = 1,
				everforest_background = "medium",
				everforest_ui_contrast = "medium",
				everforest_enable_italic = 1,
				everforest_diagnostic_virtual_text = "colored",
				everforest_disable_italic_comment = 0,
				everforest_transparent_background = 1,
			}

			if vim.g.neovide then
				Variable.g {
					everforest_transparent_background = 0,
				}
			end
		end,
		config = function()
			-- vim.cmd [[ silent! colorscheme everforest ]]
			vim.cmd [[ hi PmenuSel blend=0]]
		end,
	},

	-- {
	-- 	"sainnhe/edge",
	-- 	-- lazy = true,
	-- 	priority = 1000,
	-- 	init = function()
	-- 		vim.go.background = "dark"
	-- 		Variable.g {
	-- 			edge_better_performance = 1,
	-- 			edge_disable_terminal_colors = 1,
	-- 			edge_style = "neon",
	-- 			edge_enable_italic = 1,
	-- 			edge_diagnostic_virtual_text = "colored",
	-- 			edge_disable_italic_comment = 0,
	-- 			edge_transparent_background = 1,
	-- 			edge_diagnostic_text_highlight = 0,
	-- 			edge_inlay_hints_background = "none",
	-- 			-- edge_current_word = "underline",
	-- 		}

	-- 		if vim.g.neovide then
	-- 			Variable.g {
	-- 				edge_transparent_background = 0,
	-- 			}
	-- 		end
	-- 	end,
	-- 	config = function()
	-- 		vim.cmd [[ silent! colorscheme edge ]]
	-- 		vim.cmd [[ hi PmenuSel blend=0 ]]
	-- 	end,
	-- },

	{
		"tweekmonster/startuptime.vim",
		cmd = "StartupTime",
	},
}
