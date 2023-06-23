local M = {}

local Path = require "plenary.path"

local env = function(name)
	return vim.api.nvim_eval("$" .. name)
end

M.get_python_path = function()
	local venv_path = env "VIRTUAL_ENV"
	local conda_prefix = env "CONDA_PREFIX"
	local conda_python_exe = env "CONDA_PYTHON_EXE"

	if venv_path ~= "" then
		return venv_path .. "/bin/python"
	elseif conda_prefix ~= "" then
		return conda_prefix .. "/bin/python3"
	elseif conda_python_exe ~= "" then
		return conda_python_exe
	end

	return "/usr/bin/python3"
end

M.get_stubs_path = function()
	local stubsPath = Path:new(env "CONDA_EXE")
	stubsPath = stubsPath:parent():parent():joinpath "typings"
	if stubsPath:exists() then
		return stubsPath.filename
	else
		return nil
	end
end

M.get_ranger_cmd = function()
	if vim.uv.os_uname().sysname:find("Darwin", 1, true) and true then
		local Path = require "plenary.path"
		local ranger_cmd = Path:new(vim.api.nvim_eval "$CONDA_EXE")
		ranger_cmd = ranger_cmd:parent() / "ranger"
		return ranger_cmd.filename
	else
		return "ranger"
	end
end

return M
