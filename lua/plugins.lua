-- This file can be loaded by calling `lua require('plugins')` from your init.vim

require "utils"

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
				Variable.g {
					vimtex_quickfix_mode = 1,
				}
			end,
		}

		-- #TODO: Unstable [WIP]
		-- https://github.com/neovim/nvim-lspconfig/pull/863
		-- use {
		-- 	"brymer-meneses/grammar-guard.nvim",
		-- 	requires = "neovim/nvim-lspconfig",
		-- 	config = function()
		-- 		require("grammar-guard").init()
		-- 	end,
		-- }

		use {
			"romgrk/barbar.nvim",
			config = [[require('config.barbar')]],
			requires = { "kyazdani42/nvim-web-devicons" },
		}

		-- Use specific branch, dependency and run lua file after load
		use {
			"kyazdani42/nvim-tree.lua",
			config = [[require('config.nvim-tree')]],
			requires = { "kyazdani42/nvim-web-devicons" },
		}

		-- vista.vim: A tagbar alternative that supports LSP symbols and async processing
		use {
			"liuchengxu/vista.vim",
			config = function()
				Variable.g {
					vista_default_executive = "nvim_lsp",
				}
				nnoremap { "<F3>", ":Vista!!<CR>" }
			end,
		}

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

		-- use {
		-- 	"vim-test/vim-test",
		-- 	config = [[require('config.vim-test')]],
		-- }

		-- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
		-- related works: godlygeek/tabular
		use {
			"junegunn/vim-easy-align",
			config = function() -- Start interactive EasyAlign in visual mode (e.g. vipga)        xmap{ "ga", "<Plug>(EasyAlign)" }
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
			config = [[require('config.vim-mundo')]],
		}

		-- Lang extra
		use {
			"neovim/nvim-lspconfig",
			requires = "rcarriga/nvim-notify",
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

		-- """ edting
		use "chrisbra/NrrwRgn"

		use {
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup {}
				require "config.nvim-autopairs"
			end,
		}

		-- Snippet support
		-- " https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
		-- " UltiSnips will search each 'runtimepath' directory for the subdirectory names
		-- " defined in g:UltiSnipsSnippetDirectories in the order they are defined.
		-- " Note that "snippets" is reserved for snipMate snippets and cannot be used in this list.
		-- " If the list has only one entry that is an absolute path, UltiSnips will not
		-- " iterate through &runtimepath but only look in this one directory for snippets.
		-- " This can lead to significant speedup. This means you will miss out on snippets
		-- " that are shipped with third party plugins. You'll need to copy them into this
		-- " directory manually.
		-- " mkdir -p $HOME/.config/nvim/UltiSnip

		-- use {
		-- 	"SirVer/ultisnips",
		-- 	requires = { "honza/vim-snippets" },
		-- 	config = [[require('config.ultisnips')]],
		-- }

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
			end,
		}

		-- " https://github.com/RishabhRD/nvim-cheat.sh
		-- " curl -sSf https://cht.sh/:cht.sh > ~/.local/bin/cht.sh && chmod +x ~/.local/bin/cht.sh
		use "RishabhRD/nvim-cheat.sh"

		use {
			"mfussenegger/nvim-dap",
			requires = { "theHamsta/nvim-dap-virtual-text" },
			config = [[require('config.nvim-dap')]],
		}

		use {
			"rcarriga/nvim-dap-ui",
			requires = { "mfussenegger/nvim-dap" },
			config = function()
				require("dapui").setup {
					sidebar = { size = 80 },
				}
			end,
		}

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
		use "kevinhwang91/nvim-bqf"

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

		-- VCS
		-- https://github.com/lambdalisue/gina.vim
		use "lambdalisue/gina.vim"

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

		use "tpope/vim-surround"
		use "tpope/vim-repeat"
		-- " unimpaired has many useful maps, like
		-- " ]p pastes on the line below, [p pastes on the line above
		use "tpope/vim-unimpaired"

		-- " Use gcc to comment out a line (takes a count),
		-- " gc to comment out the target of a motion (for example, gcap to comment out a paragraph),
		-- " gc in visual mode to comment out the selection, and gc in operator pending mode to target a comment.
		-- " You can also use it as a command, either with a range like :7,17Commentary, or
		-- " as part of a :global invocation like with :g/TODO/Commentary. That's it.
		use "tpope/vim-commentary"

		-- Press + to expand the visual selection and _ to shrink it.
		use "terryma/vim-expand-region"

		use "wellle/targets.vim"

		-- " Plug 'easymotion/vim-easymotion'
		-- " like https://github.com/easymotion/vim-easymotion
		-- " https://github.com/goldfeld/vim-seek
		-- " emulate easymotion label and jump mode
		-- "justinmk/vim-sneak"
		use {
			"phaazon/hop.nvim",
			config = [[require('config.hop')]],
		}

		use {
			"mg979/vim-visual-multi",
			branch = "master",
		}

		use {
			"mfussenegger/nvim-lint",
			config = [[require('config.nvim-lint')]],
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

		-- --  https://github.com/iamcco/markdown-preview.nvim
		-- use {
		-- 	"iamcco/markdown-preview.nvim",
		-- 	run = function()
		-- 		vim.cmd "call mkdp#util#install()"
		-- 	end,
		-- 	config = [[require('config.markdown-preview')]],
		-- }

		-- -- https://github.com/plasticboy/vim-markdown#options
		-- use {
		-- 	"plasticboy/vim-markdown",
		-- 	config = [[require('config.vim-markdown')]],
		-- }

		-- use {
		-- 	"dhruvasagar/vim-table-mode",
		-- 	-- For Markdown-compatible tables use
		-- 	config = function()
		-- 		vim.g.table_mode_corner = "|"
		-- 	end,
		-- }

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

		-- " colorscheme
		use {
			"sainnhe/sonokai",
			config = function()
				Variable.g {
					sonokai_style = "shusia",
					sonokai_enable_italic = 1,
					sonokai_disable_italic_comment = 0,
					sonokai_transparent_background = 1,
				}
				vim.go.background = "dark"
				vim.cmd [[ silent! colorscheme sonokai ]]
			end,
		}
		use {
			"sainnhe/edge",
			config = function()
				Variable.g {
					edge_style = "default",
					edge_enable_italic = 1,
					edge_disable_italic_comment = 0,
					edge_transparent_background = 0,
				}
				vim.go.background = "light"
				-- vim.cmd [[ silent! colorscheme edge ]]
			end,
		}
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
