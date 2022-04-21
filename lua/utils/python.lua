local M = {}

M.get_python_path = function()
	local venv_path = os.getenv "VIRTUAL_ENV"
	local conda_python_exe = os.getenv "CONDA_PYTHON_EXE"
	if venv_path then
		return venv_path .. "/bin/python"
	elseif conda_python_exe then
		return conda_python_exe
	end

	return "/usr/bin/python3"
end

return M
