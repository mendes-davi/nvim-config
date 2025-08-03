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
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		"LSP List Workspace Folders",
		silent = true,
		buffer = bufnr,
	}

	-- inlayHint
	if supports "textDocument/inlayHint" then
		vim.lsp.inlay_hint.enable(true)
	end

	-- omnifunc
	if supports "textDocument/completion" then
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	end

	-- formatting
	if supports "textDocument/formatting" then
		vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
		nnoremap { "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "LSP Format", silent = true, buffer = bufnr }
	end
	if supports "textDocument/rangeFormatting" then
		vnoremap { "<leader>gq", "<cmd>lua vim.lsp.formatexpr()<CR>", "LSP Format", silent = true, buffer = bufnr }
	end

	if supports "textDocument/declaration" then
		nnoremap { "gD", lsp.declaration, "LSP Declaration", silent = true, buffer = bufnr }
	end

	if supports "textDocument/definition" then
		vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
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

vim.lsp.config(
	"vhdl_ls",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
		cmd = { vim.fn.stdpath "data" .. "/vhdl_ls/bin/vhdl_ls" },
	}
)
vim.lsp.enable "vhdl_ls"

-- https://github.com/mathworks/MATLAB-language-server
vim.lsp.config(
	"matlab_ls",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
		cmd = { "node", vim.fn.stdpath "data" .. "/MATLAB-language-server/out/index.js", "--stdio" },
		root_dir = function(fname)
			return util.root_pattern ".matlab_ls"(fname) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
		end,
		settings = {
			matlab = {
				indexWorkspace = true,
				installPath = "",
				matlabConnectionTiming = "onStart",
				telemetry = false,
			},
		},
	}
)
vim.lsp.enable "matlab_ls"

vim.lsp.config(
	"texlab",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
		chktex = {
			onEdit = false,
			onOpenAndSave = true,
		},
	}
)
vim.lsp.enable "texlab"

-- vim.lsp.config(
-- 	"ltex",
-- 	coq.lsp_ensure_capabilities {
-- 		on_attach = mix_attach,
-- 		capabilities = capabilities,
-- 		filetypes = { "markdown", "org", "plaintex", "tex" },
-- 		root_dir = function(fname)
-- 			return util.root_pattern "ltex_config.json"(fname) or util.find_git_ancestor(fname)
-- 		end,
-- 		single_file_support = true,
-- 		settings = {
-- 			ltex = {
-- 				language = "pt-BR",
-- 				diagnosticSeverity = "hint",
-- 				sentenceCacheSize = 2000,
-- 				additionalRules = {
-- 					enablePickyRules = true,
-- 					motherTongue = "pt-BR",
-- 				},
-- 				trace = { server = "off" },
-- 				dictionary = {},
-- 				disabledRules = {},
-- 				hiddenFalsePositives = {},
-- 			},
-- 		},
-- 	}
-- )
-- vim.lsp.enable("ltex", false)

vim.lsp.config(
	"bashls",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
	}
)
vim.lsp.enable "bashls"

-- https://clangd.llvm.org/features.html
vim.lsp.config(
	"clangd",
	coq.lsp_ensure_capabilities {
		settings = {
			clangd = {
				Index = { Background = "Build" },
			},
		},
		on_attach = mix_attach,
		capabilities = capabilities,
	}
)
vim.lsp.enable "clangd"

local pythonPath = require("utils.python").get_python_path()
local stubPath = require("utils.python").get_stubs_path()

vim.lsp.config(
	"pyright",
	coq.lsp_ensure_capabilities {
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
	}
)
vim.lsp.enable "pyright"

vim.lsp.config(
	"lua_ls",
	coq.lsp_ensure_capabilities {
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
	}
)
vim.lsp.enable "lua_ls"

vim.lsp.config(
	"vimls",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
	}
)
vim.lsp.enable "vimls"

vim.lsp.config(
	"jsonls",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
	}
)
vim.lsp.enable "jsonls"

vim.lsp.config(
	"solargraph",
	coq.lsp_ensure_capabilities {
		on_attach = mix_attach,
		capabilities = capabilities,
	}
)
vim.lsp.enable "solargraph"
