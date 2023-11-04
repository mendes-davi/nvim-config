-- This file can be loaded by calling `lua require('plugins')` from your init.vim

require "utils"

-- lewis6991/impatient.nvim
local ok, _ = pcall(require, "impatient")
if not ok then
	print(tostring(ok) .. " impatient")
end

-- make the linter happy
local use = require("packer").use

return require("packer").startup {
	function()
		-- Packer can manage itself as an optional plugin
		use { "wbthomason/packer.nvim", opt = true }

		-- treesitter = AST (syntax/parsing)
		-- LSP = whole-project semantic analysis
		-- https://github.com/nvim-treesitter/nvim-treesitter
		use {
			requires = { "nvim-treesitter/nvim-treesitter-textobjects" },
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = [[require('config.nvim-treesitter')]],
		}

		use {
			"nvim-treesitter/playground",
			requires = { "nvim-treesitter/nvim-treesitter" },
			cmd = { "TSPlaygroundToggle", "TSNodeUnderCursor", "TSCaptureUnderCursor" },
		}

		use {
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "BufReadPost",
			requires = { "nvim-treesitter/nvim-treesitter" },
		}

		use {
			"tiagovla/scope.nvim",
			config = function()
				require("scope").setup()
			end,
		}

		use {
			"lervag/vimtex",
			ft = { "tex", "latex", "bib" },
			config = function()
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
		}

		use {
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
		}

		use {
			"romgrk/barbar.nvim",
			config = [[require('config.barbar')]],
			requires = { "kyazdani42/nvim-web-devicons" },
		}

		use {
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			cmd = {
				"NvimTreeToggle",
				"NvimTreeOpen",
				"NvimTreeClose",
				"NvimTreeFocus",
				"NvimTreeFindFileToggle",
				"NvimTreeResize",
				"NvimTreeCollapse",
				"NvimTreeCollapseKeepBuffers",
			},
			setup = function()
				map { "<F4>", "<cmd> NvimTreeToggle<CR>", "NvimTree" }
			end,
			config = [[require('config.nvim-tree')]],
		}

		-- vista.vim: A tagbar alternative that supports LSP symbols and async processing
		use {
			"liuchengxu/vista.vim",
			cmd = "Vista",
			config = function()
				Variable.g {
					vista_default_executive = "nvim_lsp",
					vista_disable_statusline = 1,
				}
			end,
			setup = function()
				nnoremap { "<F3>", "<cmd> Vista!!<CR>", "Vista Outline" }
			end,
		}

		-- support split window resizing and moving
		-- resize windows continuously by using typical keymaps of Vim. (h, j, k, l)
		use {
			"simeji/winresizer",
			keys = "<C-e>",
			config = function()
				Variable.g {
					winresizer_start_key = "<C-e>",
				}
			end,
		}

		-- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
		-- related works: godlygeek/tabular
		use {
			"junegunn/vim-easy-align",
			config = function()
				-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
				nmap { "ga", "<Plug>(EasyAlign)" }
				-- Start interactive EasyAlign in visual mode (e.g. vipga)
				xmap { "ga", "<Plug>(EasyAlign)" }
			end,
		}

		-- https://github.com/simnalamburt/vim-mundo
		-- the diff https://github.com/simnalamburt/vim-mundo/issues/50
		-- https://simnalamburt.github.io/vim-mundo/#configuration
		use {
			"simnalamburt/vim-mundo",
			cmd = { "MundoHide", "MundoShow", "MundoToggle" },
			config = [[require('config.vim-mundo')]],
			setup = function()
				nnoremap { "<F9>", "<cmd> MundoToggle<CR>", "Toggle Mundo" }
			end,
		}

		use {
			"folke/which-key.nvim",
			config = [[require('config.which-key')]],
		}

		-- Lang extra
		use {
			"neovim/nvim-lspconfig",
			requires = { "rcarriga/nvim-notify", "p00f/clangd_extensions.nvim" },
			config = [[require('config.nvim-lspconfig')]],
		}

		-- https://github.com/ray-x/lsp_signature.nvim
		use "ray-x/lsp_signature.nvim"

		-- A pretty diagnostics list to help you solve all the trouble your code is causing.
		-- https://github.com/folke/lsp-trouble.nvim
		use {
			"folke/lsp-trouble.nvim",
			config = [[require('config.lsp-trouble')]],
		}

		use {
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("todo-comments").setup {}
			end,
		}

		-- notification
		use {
			"rcarriga/nvim-notify",
			config = function()
				local notify = require "notify"
				notify.setup {
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
		}

		-- """ edting
		use "chrisbra/NrrwRgn"

		use {
			"L3MON4D3/LuaSnip",
			config = [[require('config.luasnip')]],
		}

		-- LuaSnip source for coq_nvim
		use { "~/repo/coq_luasnip" }

		-- complete plugin
		use {
			"ms-jpq/coq_nvim",
			branch = "coq",
			requires = { "windwp/nvim-autopairs" },
			setup = function()
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
			config = [[require('config.coq')]],
		}
		use {
			"ms-jpq/coq.thirdparty",
			branch = "3p",
			config = [[require('config.coq_3p')]],
		}

		use {
			"mfussenegger/nvim-dap",
			requires = { "theHamsta/nvim-dap-virtual-text" },
			config = [[require('config.nvim-dap')]],
		}

		use {
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
		}

		use {
			"rcarriga/nvim-dap-ui",
			module = "dapui",
			requires = { "mfussenegger/nvim-dap" },
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
		}

		use { "jbyuki/one-small-step-for-vimkind" }

		use {
			"echasnovski/mini.nvim",
			branch = "main",
			config = [[require('config.mini')]],
		}

		-- statuscol
		use {
			"luukvbaal/statuscol.nvim",
			config = [[require('config.statuscol')]],
		}

		-- quickfix
		-- " https://github.com/kevinhwang91/nvim-bqf
		use {
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
		}

		use {
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				},
			},
			config = [[require('config.telescope')]],
		}

		use {
			"numtostr/FTerm.nvim",
			config = [[require('config.fterm')]],
		}

		use {
			"luochen1990/rainbow",
			config = function()
				Variable.g {
					rainbow_active = 1,
				}
			end,
		}

		use {
			"freddiehaddad/feline.nvim",
			config = [[require('config.feline')]],
		}

		use {
			"mhartington/formatter.nvim",
			config = [[require('config.formatter')]],
		}

		use "tpope/vim-surround"
		use "tpope/vim-repeat"
		-- use "tpope/vim-unimpaired"

		use {
			"numToStr/Comment.nvim",
			event = "BufRead",
			config = function()
				require("Comment").setup {
					-- ignore empty lines for comments
					ignore = "^$",

					pre_hook = function(ctx)
						return require("ts_context_commentstring.internal").calculate_commentstring()
					end,
				}
				nmap { "<A-/>", "<cmd> lua require('Comment.api').toggle.linewise.current()<CR>" }
				vmap { "<A-/>", "<esc><cmd> lockmarks lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>" }
				imap { "<A-/>", "<cmd> lua require('Comment.api').toggle.linewise.current()<CR>" }
			end,
		}

		use "wellle/targets.vim"

		use {
			"mg979/vim-visual-multi",
			keys = "<C-n>",
			branch = "master",
		}

		use {
			"mfussenegger/nvim-lint",
			event = "BufRead",
			config = [[require('config.nvim-lint')]],
			setup = function()
				nnoremap { "gl", "<cmd> lua require('lint').try_lint()<CR>", "Lint" }
			end,
		}

		use {
			"lewis6991/gitsigns.nvim",
			event = "BufRead",
			requires = { "nvim-lua/plenary.nvim" },
			config = [[require('config.gitsigns')]],
		}

		use {
			"sindrets/diffview.nvim",
			cmd = {
				"DiffviewClose",
				"DiffviewFileHistory",
				"DiffviewFocusFiles",
				"DiffviewOpen",
				"DiffviewRefresh",
				"DiffviewToggleFiles",
			},
			requires = { "nvim-lua/plenary.nvim" },
		}

		use {
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		}

		use {
			"rrethy/vim-illuminate",
			config = [[require('config.illuminate')]],
		}

		use {
			"folke/zen-mode.nvim",
			cmd = { "ZenMode" },
			setup = function()
				nnoremap { "<A-d>", "<cmd> ZenMode<CR>" }
			end,
			config = function()
				require("zen-mode").setup {
					plugins = { tmux = { enabled = true }, alacritty = { enabled = true, font = "13" } },
				}
			end,
		}

		use {
			"numToStr/Navigator.nvim",
			config = function()
				require("Navigator").setup {
					auto_save = "current",
					disable_on_zoom = false,
				}
				nnoremap { "<A-h>", "<cmd> lua require('Navigator').left()<CR>" }
				nnoremap { "<A-k>", "<cmd> lua require('Navigator').up()<CR>" }
				nnoremap { "<A-l>", "<cmd> lua require('Navigator').right()<CR>" }
				nnoremap { "<A-j>", "<cmd> lua require('Navigator').down()<CR>" }
				nnoremap { "<A-\\>", "<cmd> lua require('Navigator').previous()<CR>" }
			end,
		}

		use {
			"bfredl/nvim-miniyank",
			config = [[require('config.nvim-miniyank')]],
		}

		use {
			"rmagatti/auto-session",
			requires = "rmagatti/session-lens",
			config = [[require('config.auto-session')]],
		}

		use {
			"kevinhwang91/rnvimr",
			setup = function()
				nnoremap { "<A-o>", "<cmd> RnvimrToggle<CR>" }
				tnoremap { "<A-o>", "<cmd> RnvimrToggle<CR>" }
			end,
			config = function()
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
		}

		use {
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

				perfanno.setup {
					-- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300"
					line_highlights = util.make_bg_highlights("#37343A", "#CC3300", 4),
					vt_highlight = util.make_fg_highlight "#CC3300",
				}
			end,
		}

		use {
			"phaazon/mind.nvim",
			setup = function()
				nmap { "<F10>", "<cmd>MindOpenSmartProject<CR>", "Mind Main View" }
			end,
			config = [[require('config.mind')]],
		}

		use {
			"lukas-reineke/indent-blankline.nvim",
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
		}
				}
			end,
		}

		-- " colorscheme
		use {
			"sainnhe/sonokai",
			setup = function()
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
		}

		use {
			"sainnhe/everforest",
			opt = true,
			setup = function()
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
				-- vim.go.background = "dark"
				-- vim.cmd [[ silent! colorscheme everforest ]]
				-- vim.cmd [[ hi PmenuSel blend=0]]
			end,
		}

		use { "tweekmonster/startuptime.vim", cmd = "StartupTime" }
		use "lewis6991/impatient.nvim"
	end,

	config = {
		display = {
			non_interactive = os.getenv "PACKER_NON_INTERACTIVE" or false,
			open_fn = function()
				return require("packer.util").float { border = "single" }
			end,
		},
	},
}
