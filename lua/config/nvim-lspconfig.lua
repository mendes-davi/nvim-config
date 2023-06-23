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

--@param client: (required, vim.lsp.client)
local mix_attach = function(client, bufnr)
	local supports = client.supports_method
	local lsp = vim.lsp.buf

	nnoremap { "<Leader>wa", lsp.add_workspace_folder, "LSP Add Workspace Folder", silent = true, buffer = bufnr }
	nnoremap { "<Leader>wr", lsp.remove_workspace_folder, "LSP Remove Workspace Folder", silent = true, buffer = bufnr }
	nnoremap {
		"<Leader>wl",
		function()
			return vim.pretty_print(vim.lsp.buf.list_workspace_folders())
		end,
		"LSP List Workspace Folders",
		silent = true,
		buffer = bufnr,
	}

	-- inlayHint
	if supports "textDocument/inlayHint" then
		lsp.buf.inlay_hint(bufnr, true)
	end

	-- omnifunc
	if supports "textDocument/completion" then
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	end

	-- formatting
	if supports "textDocument/formatting" then
		vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		nnoremap { "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "LSP Format", silent = true, buffer = bufnr }
	end
	if supports "textDocument/rangeFormatting" then
		vnoremap { "<leader>gq", "<cmd>lua vim.lsp.formatexpr()<CR>", "LSP Format", silent = true, buffer = bufnr }
	end

	if supports "textDocument/declaration" then
		nnoremap { "gD", lsp.declaration, "LSP Declaration", silent = true, buffer = bufnr }
	end

	if supports "textDocument/definition" then
		nnoremap { "gd", lsp.definition, "LSP Definition", silent = true, buffer = bufnr }
	end

	if supports "textDocument/hover" then
		nnoremap { "K", lsp.hover, "LSP Hover", silent = true, buffer = bufnr }
	end

	if supports "textDocument/signatureHelp" then
		nnoremap { "<C-k>", lsp.signature_help, silent = true, buffer = bufnr }
	end

	if supports "textDocument/implementation" then
		nnoremap { "gi", lsp.implementation, "LSP Implementation", silent = true, buffer = bufnr }
	end

	if supports "textDocument/references" then
		nnoremap { "gr", lsp.references, "LSP References", silent = true, buffer = bufnr }
	end

	if supports "textDocument/typeDefinition" then
		nnoremap { "<Leader>D", lsp.type_definition, "LSP Type Definition", silent = true, buffer = bufnr }
	end

	if supports "textDocument/rename" then
		nnoremap { "<Leader>rn", lsp.rename, "LSP Rename", silent = true, buffer = bufnr }
		nnoremap { "<F2>", lsp.rename, "LSP Rename", silent = true, buffer = bufnr }
	end

	if supports "textDocument/documentSymbol" then
		nnoremap { "g0", lsp.document_symbol, "LSP Document Symbols", silent = true, buffer = bufnr }
	end

	if supports "textDocument/symbol" then
		nnoremap { "gW", lsp.workspace_symbol, "LSP Workspace Symbols", silent = true, buffer = bufnr }
	end

	-- ga has been mapped to vim-easy-align
	-- commentary took gc and gcc, so ...
	-- lsp builtin code_action
	if supports "textDocument/codeAction" then
		nnoremap { "<leader>ca", lsp.code_action, "LSP Code Action", silent = true, buffer = bufnr }
		vnoremap { "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", "LSP Code Action", silent = true, buffer = bufnr }
	end

	if supports "textDocument/prepareCallHierarchy" then
		nnoremap { "ghi", lsp.incoming_calls, "LSP Incoming Calls", silent = true, buffer = bufnr }
		nnoremap { "gho", lsp.outgoing_calls, "LSP Outgoing Calls", silent = true, buffer = bufnr }
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

lsp.vhdl_ls.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
	cmd = { vim.fn.stdpath "data" .. "/vhdl_ls/bin/vhdl_ls" },
})

lsp.texlab.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
	chktex = {
		onEdit = false,
		onOpenAndSave = true,
	},
})

-- lsp.ltex.setup(coq.lsp_ensure_capabilities {
-- 	on_attach = mix_attach,
-- 	capabilities = capabilities,
-- 	filetypes = { "markdown", "org", "plaintex", "tex" },
-- 	root_dir = function(fname)
-- 		return util.root_pattern "ltex_config.json"(fname) or util.find_git_ancestor(fname)
-- 	end,
-- 	single_file_support = true,
-- 	settings = {
-- 		ltex = {
-- 			language = "pt-BR",
-- 			diagnosticSeverity = "hint",
-- 			sentenceCacheSize = 2000,
-- 			additionalRules = {
-- 				enablePickyRules = true,
-- 				motherTongue = "pt-BR",
-- 			},
-- 			trace = { server = "off" },
-- 			dictionary = {},
-- 			disabledRules = {},
-- 			hiddenFalsePositives = {},
-- 		},
-- 	},
-- })

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
	extensions = {
		autoSetHints = true,
		inlay_hints = {
			show_parameter_hints = true,
			parameter_hints_prefix = " ",
			other_hints_prefix = " ",
			highlight = "Comment",
			priority = 100,
		},
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
local stubPath = require("utils.python").get_stubs_path()

lsp.pyright.setup(coq.lsp_ensure_capabilities {
	flags = { debounce_text_changes = 150 },
	settings = {
		python = {
			pythonPath = pythonPath,
			workspaceSymbols = { enabled = true },
			analysis = { autoSearchPaths = false, useLibraryCodeForTypes = true, diagnosticMode = "openFilesOnly", stubPath = stubPath },
		},
	},
	on_attach = mix_attach,
	capabilities = capabilities,
})

lsp.lua_ls.setup(coq.lsp_ensure_capabilities {
	on_attach = mix_attach,
	capabilities = capabilities,
	log_level = vim.lsp.protocol.MessageType.Log,
	message_level = vim.lsp.protocol.MessageType.Log,
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
			hint = {
				enable = true,
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
