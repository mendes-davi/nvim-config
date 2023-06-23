--
-- bootstrapping
--
local pluginman_opt = true
local pluginman_repo = "https://github.com/wbthomason/packer.nvim"
local print_err = vim.api.nvim_err_writeln
local execute = vim.api.nvim_command

local bootstrap = function()
	local fn = vim.fn

	-- opt:   site/pack/packer/opt/packer.nvim
	-- start: site/pack/packer/start/packer.nvim
	local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
	if pluginman_opt then
		install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
	end

	if fn.empty(fn.glob(install_path)) > 0 then
		print("packer.nvim not found in " .. install_path .. ", try install ...")
		fn.system { "git", "clone", pluginman_repo, install_path }
		if pluginman_opt then
			execute "packadd packer.nvim"
		end
		print("packer.nvim installed to " .. install_path)
	end
end

bootstrap()

-- Only required if you have packer in your `opt` pack
if pluginman_opt then
	execute "packadd packer.nvim"
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "general.lua", "plugins.lua" },
	command = "source <afile> | PackerCompile",
})

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

require "utils"

require "general"
require "autocmds"

local plugins = require "plugins"
