local lsp = require "lspconfig"
local util = require "lspconfig.util"
local coq = require "coq"

require("lsp").setup_diagnostic_sign()
require("lsp").setup_item_kind_icons()

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- by default, NeoVim lsp disabled snippet, see https://github.com/neovim/neovim/pull/13183
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

nnoremap { "<space>ee", "<cmd>lua vim.diagnostic.open_float()<CR>", silent = true }

-- toggle diagnostics loclist, open loclist if there are diagnostics severity >= WARN, else show a notify info. if loclist open, close it
-- nnoremap { "<space>e", "<cmd>lua vim.diagnostic.setloclist({severity = vim.diagnostic.severity.WARN})<CR>", silent = true }
nnoremap {
	"<space>e",
	function()
		local loc = vim.fn.getloclist(0)
		if loc and type(loc) == "table" and #loc > 0 then
			-- close the loclist
			vim.api.nvim_command "lclose"
			-- clear the loclist
			vim.fn.setloclist(0, {})
			return
		end

		local diag = vim.diagnostic.get(0, { severity_limit = vim.diagnostic.severity.WARN })
		if diag and type(diag) == "table" and #diag > 0 then
			vim.diagnostic.setloclist { severity_limit = vim.diagnostic.severity.WARN }
		else
			require "notify"({ "no diagnostics meet the severity level >= warn." }, "INFO", { title = "QF - Diagnostics" })
		end
	end,
	silent = true,
}

-- diag https://github.com/nvim-lua/diagnostic-nvim/issues/73
-- nnoremap <leader>dn <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
nnoremap { "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", silent = true }
nnoremap { "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", silent = true }

--@param client: (required, vim.lsp.client)
local mix_attach = function(client, bufnr)
	local supports = client.supports_method
	local lsp = vim.lsp.buf

	nnoremap { "<Leader>wa", lsp.add_workspace_folder, silent = true, buffer = bufnr }
	nnoremap { "<Leader>wr", lsp.remove_workspace_folder, silent = true, buffer = bufnr }
	nnoremap {
		"<Leader>wl",
		function()
			return vim.pretty_print(vim.lsp.buf.list_workspace_folders())
		end,
		silent = true,
		buffer = bufnr,
	}

	-- omnifunc
	if supports "textDocument/completion" then
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	end

	-- formatting
	if supports "textDocument/formatting" then
		vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		nnoremap { "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", silent = true, buffer = bufnr }
	end
	if supports "textDocument/rangeFormatting" then
		vnoremap { "<leader>gq", lsp.range_formatting, silent = true, buffer = bufnr }
	end

	if supports "textDocument/declaration" then
		nnoremap { "gD", lsp.declaration, silent = true, buffer = bufnr }
	end

	if supports "textDocument/definition" then
		nnoremap { "gd", lsp.definition, silent = true, buffer = bufnr }
	end

	if supports "textDocument/hover" then
		nnoremap { "K", lsp.hover, silent = true, buffer = bufnr }
	end

	if supports "textDocument/signatureHelp" then
		nnoremap { "<C-k>", lsp.signature_help, silent = true, buffer = bufnr }
	end

	if supports "textDocument/implementation" then
		nnoremap { "gi", lsp.implementation, silent = true, buffer = bufnr }
	end

	if supports "textDocument/references" then
		nnoremap { "gr", lsp.references, silent = true, buffer = bufnr }
	end

	if supports "textDocument/typeDefinition" then
		nnoremap { "<Leader>D", lsp.type_definition, silent = true, buffer = bufnr }
	end

	if supports "textDocument/rename" then
		nnoremap { "<Leader>rn", lsp.rename, silent = true, buffer = bufnr }
		nnoremap { "<F2>", lsp.rename, silent = true, buffer = bufnr }
	end

	if supports "textDocument/documentSymbol" then
		nnoremap { "g0", lsp.document_symbol, silent = true, buffer = bufnr }
	end

	if supports "textDocument/symbol" then
		nnoremap { "gW", lsp.workspace_symbol, silent = true, buffer = bufnr }
	end

	-- ga has been mapped to vim-easy-align
	-- commentary took gc and gcc, so ...
	-- lsp builtin code_action
	if supports "textDocument/codeAction" then
		nnoremap { "<leader>ca", lsp.code_action, silent = true, buffer = bufnr }
		vnoremap { "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", silent = true, buffer = bufnr }
	end

	if supports "textDocument/prepareCallHierarchy" then
		nnoremap { "ghi", lsp.incoming_calls, silent = true, buffer = bufnr }
		nnoremap { "gho", lsp.outgoing_calls, silent = true, buffer = bufnr }
	end

	-- if supports "textDocument/codeLens" then
	-- 	nnoremap { "ghl", "<cmd>lua vim.lsp.codelens.run()<CR>", silent = true, buffer = bufnr }
	-- end

	local has_illuminate, illuminate = pcall(require, "illuminate")
	if has_illuminate then
		illuminate.on_attach(client)
	end

	local has_lsp_signature, lsp_signature = pcall(require, "lsp_signature")
	if has_lsp_signature then
		local cfg = {
			toggle_key = "<C-s>",
			zindex = 50,
			bind = true, -- This is mandatory, otherwise border config won't get registered.
			-- If you want to hook lspsaga or other signature handler, pls set to false
			doc_lines = 10, -- only show one line of comment set to 0 if you do not want API comments be shown

			hint_enable = true, -- virtual hint enable
			hint_prefix = "🐼 ", -- Panda for parameter
			hint_scheme = "String",

			handler_opts = {
				border = "single", -- double, single, shadow, none
			},
			decorator = { "`", "`" }, -- or decorator = {"***", "***"}  decorator = {"**", "**"} see markdown help
		}
		lsp_signature.on_attach(cfg)
	end
end

-- if not lsp.hdl_checker then
-- 	configs.hdl_checker = {
-- 		default_config = {
-- 			cmd = { "hdl_checker", "--lsp" },
-- 			filetypes = { "vhdl", "verilog", "systemverilog" },
-- 			root_dir = function(fname)
-- 				-- will look for a parent directory with a .git directory. If none, just
-- 				-- use the current directory
-- 				-- return lsp.util.find_git_ancestor(fname) or lsp.util.path.dirname(fname)
-- 				-- or (not both)
-- 				-- Will look for the .hdl_checker.config file in a parent directory. If
-- 				-- none, will use the current directory
-- 				return lsp.util.root_pattern ".hdl_checker.config"(fname) or lsp.util.path.dirname(fname)
-- 			end,
-- 			settings = {},
-- 		},
-- 	}
-- end

-- lsp.hdl_checker.setup(coq.lsp_ensure_capabilities {
-- 	on_attach = mix_attach,
-- 	capabilities = capabilities,
-- })

lsp.texlab.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
	chktex = {
		onEdit = false,
		onOpenAndSave = true,
	},
})

lsp.ltex.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
	filetypes = { "markdown", "org", "plaintex", "tex" },
	root_dir = function(fname)
		return util.root_pattern "ltex_config.json"(fname) or util.find_git_ancestor(fname)
	end,
	single_file_support = true,
	settings = {
		ltex = {
			language = "pt-BR",
			diagnosticSeverity = "hint",
			sentenceCacheSize = 2000,
			additionalRules = {
				enablePickyRules = true,
				motherTongue = "pt-BR",
			},
			trace = { server = "off" },
			dictionary = {},
			disabledRules = {},
			hiddenFalsePositives = {},
		},
	},
})

lsp.bashls.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
})

-- https://clangd.llvm.org/features.html
require("clangd_extensions").setup {
	server = {
		settings = {
			clangd = {
				Index = { Background = "Build" },
			},
		},
		init_options = {
			clangdFileStatus = true,
		},
		on_attach = mix_attach,
		capabilities = coq.lsp_ensure_capabilities(capabilities),
	},
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#ccls
-- https://github.com/MaskRay/ccls/wiki
-- lsp.ccls.setup {
--   init_options = {
-- 	  compilationDatabaseDirectory = "build";
--     index = {
--       threads = 0;
--     };
--     clang = {
--       excludeArgs = { "-frounding-math"} ;
--     };
--   }
-- }

-- lsp.pyright.setup{}
local pythonPath = require("utils.python").get_python_path()

lsp.pyright.setup(coq.lsp_ensure_capabilities {
	flags = { debounce_text_changes = 150 },
	settings = {
		python = {
			pythonPath = pythonPath,
			workspaceSymbols = { enabled = true },
			analysis = { autoSearchPaths = false, useLibraryCodeForTypes = true, diagnosticMode = "openFilesOnly" },
		},
	},
	on_attach = mix_attach,
	capabilities = capabilities,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = "/usr"
local sumneko_binary = "/usr/bin/lua-language-server"

local system_name
if vim.fn.has "mac" == 1 then
	system_name = "macOS"
	sumneko_root_path = "/usr"
	sumneko_binary = "/usr/local/bin/lua-language-server"
elseif vim.fn.has "unix" == 1 then
	system_name = "Linux"
elseif vim.fn.has "win32" == 1 then
	system_name = "Windows"
else
	print "Unsupported system for sumneko"
end

lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
	log_level = vim.lsp.protocol.MessageType.Log,
	message_level = vim.lsp.protocol.MessageType.Log,
	-- https://github.com/sumneko/lua-language-server/wiki/Setting-without-VSCode#neovim-with-built-in-lsp-client
	-- https://github.com/sumneko/lua-language-server/blob/7a63f98e41305e8deb114164e86a621881a5a2bc/script/config.lua#L96
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				version = "Lua 5.1",
				-- version = 'LuaJIT',
				-- path = vim.split(package.path, ';')
				path = {
					"?.lua",
					"?/init.lua",
					vim.fn.expand "~/.luarocks/share/lua/5.1/?.lua",
					vim.fn.expand "~/.luarocks/share/lua/5.1/?/init.lua",
					"/usr/share/lua/5.1/?.lua",
					"/usr/share/lua/5.1/?/init.lua",
				},
			},
			diagnostics = {
				enable = true,
				globals = { "vim", "describe", "it", "before_each", "after_each" },
			},
			workspace = {
				library = {
					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
					[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
				},
				maxPreload = 3000, -- default 1000
				preloadFileSize = 1024, -- default 100 ( KiB )
			},
		},
	}, -- end settings
})

lsp.vimls.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
})

lsp.jsonls.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
})

Augroup {
	LspBufWritePre = {
		["BufWritePre"] = {
			-- { "*.lua", require("lsp").formatting_sync },
			{ "*.tex", require("lsp").formatting_sync },
			-- { "*.c", require("lsp").formatting_sync },
			-- { "*.py", require("lsp").formatting_sync },
		},
	},
}
