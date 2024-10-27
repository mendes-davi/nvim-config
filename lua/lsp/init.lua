#!/usr/bin/env lua
local vim = vim
local lsp = vim.lsp

local handlers = require "lsp.handlers"

local M = {}

M.formatting_sync = function()
	vim.lsp.buf.format { async = false, timeout_ms = 1000 }
end

-- https://www.reddit.com/r/neovim/comments/l00zzb/improve_style_of_builtin_lsp_diagnostic_messages/gjt2hek/
-- https://github.com/glepnir/lspsaga.nvim/blob/cb0e35d2e594ff7a9c408d2e382945d56336c040/lua/lspsaga/diagnostic.lua#L202
M.setup_diagnostic_sign = function()
	local group = {
		err_group = {
			highlight = "DiagnosticSignError",
			sign = [[❌]],
		},
		warn_group = {
			highlight = "DiagnosticSignWarn",
			sign = [[⚠️]],
		},
		hint_group = {
			highlight = "DiagnosticSignHint",
			sign = [[💡]],
		},
		infor_group = {
			highlight = "DiagnosticSignInfo",
			sign = [[ℹ️]],
		},
	}

	for _, g in pairs(group) do
		vim.fn.sign_define(g.highlight, { text = g.sign, texthl = g.highlight, linehl = "", numhl = "" })
	end
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
