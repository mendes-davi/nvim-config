--
-- bootstrapping
--
local print_err = vim.api.nvim_err_writeln

local bootstrap = function()
	local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system {
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		}
	end
	vim.opt.rtp:prepend(lazypath)
end

bootstrap()

-- https://github.com/neovim/neovim/issues/11330
if os.getenv("TERM"):match "alacritty" ~= nil then
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		callback = function()
			local pid, WINCH = vim.fn.getpid(), vim.uv.constants.SIGWINCH
			vim.defer_fn(function()
				vim.uv.kill(pid, WINCH)
			end, 100)
		end,
	})
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local _lsp_debug = os.getenv "LSP_DEBUG" or false
if _lsp_debug then
	vim.lsp.set_log_level "trace"
	require("vim.lsp.log").set_format_func(vim.inspect)
	print [[You can find your log at $HOME/.local/state/nvim/lsp.log]]
end

if vim.g.neovide then
	require "neovide"
end

require "utils"

require "general"
require "autocmds"

local plugins = require "plugins"
