-- This file can be loaded by calling `lua require('plugins')` from your init.vim

require "utils"

vim.loader.enable()

return require("lazy").setup {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		build = ":TSUpdate",
		config = function()
			require "config.nvim-treesitter"
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		main = "ts_context_commentstring",
		opts = {
			enable_autocmd = false,
		},
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
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup {
				override = {
					tcl = {
						icon = "",
						color = "#1e5cb3",
						cterm_color = "25",
						name = "Tcl",
					},
				},
			}
		end,
	},

	{
		"romgrk/barbar.nvim",
		config = function()
			require "config.barbar"
		end,
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},

	{
		lazy = true,
		"kyazdani42/nvim-tree.lua",
		dependencies = { "kyazdani42/nvim-web-devicons" },
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

	-- nnoremap { "<F3>", "<cmd> Vista!!<CR>", "Vista Outline" }

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
		dependencies = { "rcarriga/nvim-notify", "p00f/clangd_extensions.nvim" },
		config = function()
			require "config.nvim-lspconfig"
		end,
	},

	"ray-x/lsp_signature.nvim",

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
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {}
		end,
	},

	-- notification
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require "notify"
			notify.setup {
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
			}
			vim.notify = notify
		end,
	},

	"chrisbra/NrrwRgn",

	{
		"L3MON4D3/LuaSnip",
		config = function()
			require "config.luasnip"
		end,
	},

	{
		"ms-jpq/coq_nvim",
		branch = "coq",
		dependencies = { "windwp/nvim-autopairs" },
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
		branch = "3p",
		config = function()
			require "config.coq_3p"
		end,
	},

	{
		lazy = true,
		"mfussenegger/nvim-dap",
		dependencies = { "theHamsta/nvim-dap-virtual-text" },
		config = function()
			require "config.nvim-dap"
		end,
	},

	{
		lazy = true,
		"theHamsta/nvim-dap-virtual-text",
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
		lazy = true,
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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
		},
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
		init = function()
			Variable.g {
				rainbow_active = 1,
			}
		end,
	},

	{
		"johnfrankmorgan/whitespace.nvim",
		config = function()
			require("whitespace-nvim").setup {
				highlight = "DiffDelete",
				ignored_filetypes = { "TelescopePrompt", "Trouble", "help" },
				ignore_terminal = true,
			}
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
		config = function()
			require "config.formatter"
		end,
	},

	"tpope/vim-surround",
	"tpope/vim-repeat",
	-- use "tpope/vim-unimpaired"

	{
		"numToStr/Comment.nvim",
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
		config = function()
			nnoremap { "gl", "<cmd> lua require('lint').try_lint()<CR>", "Lint" }
			require "config.nvim-lint"
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require "config.gitsigns"
		end,
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
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"rrethy/vim-illuminate",
		config = function()
			require "config.illuminate"
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = { "ZenMode" },
		init = function()
			nnoremap { "<A-d>", "<cmd> ZenMode<CR>" }
		end,
		config = function()
			require("zen-mode").setup {
				plugins = { tmux = { enabled = true }, alacritty = { enabled = true, font = "13" } },
			}
		end,
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
		main = "ibl",
		config = function()
			require("ibl").setup {
				indent = {
					char = "▏",
				},
				scope = {
					show_start = false,
					show_end = false,
				},
			}

			local hooks = require "ibl.hooks"
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
		end,
	},

	{
		"sainnhe/sonokai",
		priority = 1000,
		init = function()
			Variable.g {
				sonokai_better_performance = 1,
				sonokai_disable_terminal_colors = 1,
				sonokai_style = "espresso",
				sonokai_enable_italic = 1,
				sonokai_diagnostic_virtual_text = "colored",
				sonokai_disable_italic_comment = 0,
				sonokai_transparent_background = 1,
				-- sonokai_current_word = "underline",
			}
		end,
		config = function()
			vim.go.background = "dark"
			vim.cmd [[ silent! colorscheme sonokai ]]
			vim.cmd [[ hi PmenuSel blend=0 ]]
		end,
	},

	{
		"sainnhe/everforest",
		lazy = true,
		init = function()
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
		end,
		config = function()
			vim.go.background = "dark"
			-- vim.cmd [[ silent! colorscheme everforest ]]
			vim.cmd [[ hi PmenuSel blend=0]]
		end,
	},

	{
		"tweekmonster/startuptime.vim",
		cmd = "StartupTime",
	},
}
