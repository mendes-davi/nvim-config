#!/usr/bin/env lua
local vim = vim
local lsp = vim.lsp

local handlers = require "lsp.handlers"

local M = {}

M.formatting_sync = function()
	vim.lsp.buf.format { async = false, timeout_ms = 1000 }
end

M.setup_diagnostic_sign = function()
	vim.diagnostic.config {
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = [[❌]],
				[vim.diagnostic.severity.WARN] = [[⚠️]],
				[vim.diagnostic.severity.INFO] = [[ ]],
				[vim.diagnostic.severity.HINT] = [[💡]],
			},
			linehl = {
				[vim.diagnostic.severity.ERROR] = "Error",
				[vim.diagnostic.severity.WARN] = "Warn",
				[vim.diagnostic.severity.INFO] = "Info",
				[vim.diagnostic.severity.HINT] = "Hint",
			},
		},
		underline = {
			severity = {
				min = vim.diagnostic.severity.INFO,
			},
		},
		virtual_text = {
			spacing = 4,
			severity = {
				min = vim.diagnostic.severity.WARN,
			},
		},
	}
end

-- replace https://github.com/onsails/lspkind-nvim/blob/master/lua/lspkind/init.lua
-- code from wiki https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#completion-kinds
M.icons = {
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Enum = "了 ",
	EnumMember = " ",
	Field = " ",
	File = " ",
	Folder = " ",
	Function = " ",
	Interface = "ﰮ ",
	Keyword = " ",
	Method = "ƒ ",
	Module = " ",
	Property = " ",
	Snippet = "﬌ ",
	Struct = " ",
	Text = " ",
	Unit = " ",
	Value = " ",
	Variable = " ",
}

function M.setup_item_kind_icons()
	local kinds = vim.lsp.protocol.CompletionItemKind
	for i, kind in ipairs(kinds) do
		kinds[i] = M.icons[kind] or kind
	end
end

return M
