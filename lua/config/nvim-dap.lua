nnoremap { "<F5>", ":lua require'dap'.continue()<CR>", "DAP Continue" }
nnoremap { "<F6>", ":lua require'dap'.step_over()<CR>", "DAP Step Over" }
nnoremap { "<F7>", ":lua require'dap'.step_into()<CR>", "DAP Step Into" }
nnoremap { "<F8>", ":lua require'dap'.step_out()<CR>", "DAP Step Out" }

-- nvim-dap setup
local dap = require "dap"
-- nvim-dap uses three signs:
-- `DapBreakpoint` which defaults to `B` for breakpoints
-- `DapLogPoint` which defaults to `L` and is for log-points
-- `DapStopped` which defaults to `→` and is used to indicate the position where the debugee is stopped.

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "✳️ ", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭕", texthl = "", linehl = "", numhl = "" })

dap.defaults.fallback.terminal_win_cmd = "tabnew"
-- dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.external_terminal = {
	command = "alacritty",
	args = { "-e" },
}

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
		host = function()
			local value = vim.fn.input "Host [127.0.0.1]: "
			if value ~= "" then
				return value
			end
			return "127.0.0.1"
		end,
	},
}

dap.adapters.nlua = function(callback, config)
	callback { type = "server", host = config.host, port = config.port or 8088 }
end

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = vim.fn.stdpath "data" .. "/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
	options = {
		detached = false,
	},
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return coroutine.create(function(dap_run_co)
				local exe_files = {}
				local p = io.popen("find " .. vim.fn.getcwd() .. " -type f -executable -print")
				for file in p:lines() do
					table.insert(exe_files, file)
				end

				vim.ui.select(exe_files, { prompt = "Pick executable>" }, function(choice)
					coroutine.resume(dap_run_co, choice)
				end)
			end)
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
}
dap.configurations.c = dap.configurations.cpp
