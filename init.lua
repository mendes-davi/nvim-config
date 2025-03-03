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

-- log file location: ~/.cache/nvim/lsp.log
-- vim.lsp.set_log_level("debug")

if vim.g.neovide then
	require "neovide"
end

require "utils"

require "general"
require "autocmds"

local plugins = require "plugins"
