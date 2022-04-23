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
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = [[require('config.nvim-treesitter')]],
		}

		use {
			"nvim-treesitter/nvim-treesitter-textobjects",
			requires = { "nvim-treesitter/nvim-treesitter" },
			config = [[require('config.nvim-treesitter-textobjects')]],
		}

		-- https://github.com/nvim-treesitter/playground
		use {
			"nvim-treesitter/playground",
			requires = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				nnoremap {
					"<Leader>hl",
					[[:call luaeval("require'nvim-treesitter-playground.hl-info'.show_hl_captures()")<CR>]],
				}
			end,
		}

		use {
			"JoosepAlviste/nvim-ts-context-commentstring",
			requires = { "nvim-treesitter/nvim-treesitter" },
		}

		use {
			"lewis6991/spellsitter.nvim",
			config = function()
				require("spellsitter").setup()
			end,
		}

		use {
			"lervag/vimtex",
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
			"romgrk/barbar.nvim",
			config = [[require('config.barbar')]],
			requires = { "kyazdani42/nvim-web-devicons" },
		}

		-- Use specific branch, dependency and run lua file after load
		use {
			"kyazdani42/nvim-tree.lua",
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
			config = [[require('config.nvim-tree')]],
			requires = { "kyazdani42/nvim-web-devicons" },
		}
		map { "<F4>", "<cmd>NvimTreeToggle<CR>" }
		nnoremap { "<leader>f", "<cmd>NvimTreeToggle<CR>" }
		nnoremap { "<leader>r", "<cmd>NvimTreeRefresh<CR>" }
		nnoremap { "<leader>ff", "<cmd>NvimTreeFindFile<CR>" }

		-- vista.vim: A tagbar alternative that supports LSP symbols and async processing
		use {
			"liuchengxu/vista.vim",
			cmd = "Vista",
			config = function()
				Variable.g {
					vista_default_executive = "nvim_lsp",
				}
			end,
		}
		nnoremap { "<F3>", ":Vista!!<CR>" }

		-- support split window resizing and moving
		-- resize windows continuously by using typical keymaps of Vim. (h, j, k, l)
		use {
			"simeji/winresizer",
			config = function()
				Variable.g {
					winresizer_start_key = "<C-e>",
				}
				noremap { "<leader>nh", ":set nosplitright<CR>:vnew<CR>" }
				noremap { "<leader>nl", ":set splitright<CR>:vnew<CR>" }
				noremap { "<leader>nj", ":set splitbelow<CR>:new<CR>" }
				noremap { "<leader>nk", ":set nosplitbelow<CR>:new<CR>" }
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
		}

		-- Lang extra
		use {
			"neovim/nvim-lspconfig",
			requires = { "rcarriga/nvim-notify", "p00f/clangd_extensions.nvim" },
			config = [[require('config.nvim-lspconfig')]],
		}

		-- https://github.com/ray-x/lsp_signature.nvim
		use "ray-x/lsp_signature.nvim"

		-- https://github.com/glepnir/lspsaga.nvim
		use {
			"tami5/lspsaga.nvim",
			config = [[require('config.lspsaga')]],
		}

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
				require("notify").setup {
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
			end,
		}

		-- """ edting
		use "chrisbra/NrrwRgn"

		use {
			"windwp/nvim-autopairs",
			config = [[require('config.nvim-autopairs')]],
		}

		use {
			"SirVer/ultisnips",
			config = [[require('config.ultisnips')]],
		}

		-- complete plugin
		use {
			"ms-jpq/coq_nvim",
			branch = "coq",
			setup = function()
				Variable.g {
					coq_settings = {
						display = { icons = { mappings = require("lsp").icons } },
						keymap = { recommended = false, manual_complete = "<A-Space>" },
						auto_start = "shut-up",
						clients = {
							tabnine = {
								enabled = false,
							},
						},
					},
				}
			end,
		}
		use {
			"ms-jpq/coq.thirdparty",
			branch = "3p",
			config = function()
				require "coq_3p" {
					{ src = "vimtex", short_name = "vTEX" },
					{ src = "nvimlua", short_name = "nLUA", conf_only = true },
					{ src = "dap" },
				}
				COQsources = COQsources or {}
				local utils = require "coq_3p.utils"
				COQsources[utils.new_uid(COQsources)] = {
					name = "UltiSnips",
					fn = function(args, callback)
						local items = {}

						-- label      :: display label
						-- insertText :: string | null, default to `label` if null
						-- kind       :: int ∈ `vim.lsp.protocol.CompletionItemKind`
						-- detail     :: doc popup

						for key, val in pairs(vim.fn["UltiSnips#SnippetsInCurrentScope"]()) do
							local item = {
								label = tostring(key),
								insertText = key,
								detail = tostring(val),
								kind = vim.lsp.protocol.CompletionItemKind.Snippet,
							}
							table.insert(items, item)
						end
						callback { isIncomplete = true, items = items }
					end,
				}
			end,
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
			requires = { "mfussenegger/nvim-dap" },
			config = function()
				require("dapui").setup {
					sidebar = { size = 40 },
				}
			end,
		}

		use { "jbyuki/one-small-step-for-vimkind" }

		use {
			"dstein64/nvim-scrollview",
			branch = "main",
			config = function()
				Variable.g {
					scrollview_hide_on_intersect = true,
					scrollview_on_startup = true,
					scrollview_excluded_filetypes = {
						"NvimTree",
						"packer",
						"startify",
						"fugitive",
						"fugitiveblame",
						"vista_kind",
						"qf",
						"help",
					},
				}
			end,
		}

		-- quickfix
		-- " https://github.com/kevinhwang91/nvim-bqf
		use { "kevinhwang91/nvim-bqf", ft = "qf" }

		use {
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzy-native.nvim", run = "make" } },
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
					-- " oblitum mod version has bug, will mess up php syntax highlighting
					-- " Plug 'oblitum/rainbow'
					-- " Plug 'kien/rainbow_parentheses.vim'
					-- " https://github.com/p00f/nvim-ts-rainbow
					-- " Plug 'p00f/nvim-ts-rainbow'
				}
			end,
		}

		use {
			"famiu/feline.nvim",
			config = [[require('config.feline')]],
		}

		use {
			"mhinz/vim-startify",
			config = [[require('config.vim-startify')]],
		}

		use {
			"mhartington/formatter.nvim",
			config = [[require('config.formatter')]],
		}

		use "gpanders/editorconfig.nvim"

		use "tpope/vim-surround"
		use "tpope/vim-repeat"
		-- " unimpaired has many useful maps, like
		-- " ]p pastes on the line below, [p pastes on the line above
		use "tpope/vim-unimpaired"

		use {
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup {
					-- ignore empty lines for comments
					ignore = "^$",

					pre_hook = function(ctx)
						return require("ts_context_commentstring.internal").calculate_commentstring()
					end,
				}
			end,
			nmap { "<M-/>", "<cmd> lua require('Comment.api').toggle_current_linewise()<CR>" },
			vmap { "<M-/>", "<Esc><cmd>lua require('Comment.api').locked.toggle_linewise_op(vim.fn.visualmode())<CR>" },
			imap { "<M-/>", "<cmd> lua require('Comment.api').toggle_current_linewise()<CR>" },
		}

		-- Press + to expand the visual selection and _ to shrink it.
		use "terryma/vim-expand-region"

		use "wellle/targets.vim"

		use {
			"mg979/vim-visual-multi",
			branch = "master",
		}

		use {
			"mfussenegger/nvim-lint",
			config = [[require('config.nvim-lint')]],
			nnoremap { "gl", "<CMD> lua require('lint').try_lint()<CR>", { silent = true } },
		}

		-- " signify show git diff sigs
		-- " Plug 'mhinz/vim-signify'
		-- " https://github.com/lewis6991/gitsigns.nvim
		-- Plug 'nvim-lua/plenary.nvim'
		-- Use dependency and run lua function after load
		use {
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = [[require('config.gitsigns')]],
		}

		use "sindrets/diffview.nvim"

		use {
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		}

		-- " illuminate.vim - Vim plugin for automatically highlighting other uses of the word under the cursor.
		-- " Integrates with Neovim's LSP client for intelligent highlighting.
		use {
			"rrethy/vim-illuminate",
			config = function()
				Variable.g {
					Illuminate_ftblacklist = { "NvimTree" },
				}
			end,
		}

		use {
			"folke/zen-mode.nvim",
			config = function()
				require("zen-mode").setup {
					plugins = { tmux = { enabled = true } },
				}
				nnoremap { "<A-d>", ":ZenMode<CR>" }
			end,
		}

		use {
			"numToStr/Navigator.nvim",
			config = function()
				require("Navigator").setup {
					auto_save = "current",
					disable_on_zoom = false,
				}
			end,
			nnoremap { "<A-h>", "<CMD> lua require('Navigator').left()<CR>", { silent = true } },
			nnoremap { "<A-k>", "<CMD> lua require('Navigator').up()<CR>", { silent = true } },
			nnoremap { "<A-l>", "<CMD> lua require('Navigator').right()<CR>", { silent = true } },
			nnoremap { "<A-j>", "<CMD> lua require('Navigator').down()<CR>", { silent = true } },
			-- nnoremap { "<A-p>", "<CMD> lua require('Navigator').previous()<CR>", { silent = true } },
		}

		use "tversteeg/registers.nvim"

		use {
			"bfredl/nvim-miniyank",
			config = [[require('config.nvim-miniyank')]],
		}

		use {
			"rmagatti/auto-session",
			config = [[require('config.auto-session')]],
		}

		use {
			"rmagatti/session-lens",
			requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
			config = function()
				require("session-lens").setup()
			end,
		}

		use {
			"kevinhwang91/rnvimr",
			config = function()
				Variable.g {
					rnvimr_enable_ex = 1,
					rnvimr_enable_picker = 1,
					-- <C-t> tab
					-- <C-x> split
					-- <C-v> vsplit
					-- gw cd
					-- yw pwd
				}
				nnoremap { "<A-o>", ":RnvimrToggle<CR>" }
				tnoremap { "<A-o>", [[<C-\><C-n>:RnvimrToggle<CR>]] }
			end,
		}

		use {
			"t-troebst/perfanno.nvim",
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

		-- " colorscheme
		use {
			"sainnhe/sonokai",
			config = function()
				local opt = { "andromeda", "default", "andromeda", "shusia", "maia", "atlantis" }
				local v = opt[math.random(1, #opt)]
				Variable.g {
					sonokai_better_performance = 1,
					sonokai_disable_terminal_colors = 1,
					sonokai_style = v,
					sonokai_enable_italic = 1,
					sonokai_diagnostic_virtual_text = "colored",
					sonokai_disable_italic_comment = 0,
					sonokai_transparent_background = 1,
					-- sonokai_current_word = "underline",
				}
				vim.go.background = "dark"
				-- vim.cmd [[ silent! colorscheme sonokai ]]
			end,
		}

		use {
			"sainnhe/everforest",
			config = function()
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
				vim.go.background = "dark"
				vim.cmd [[ silent! colorscheme everforest ]]
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
