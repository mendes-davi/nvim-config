nnoremap { "<F5>", ":lua require'dap'.continue()<CR>" }
nnoremap { "<F6>", ":lua require'dap'.step_over()<CR>" }
nnoremap { "<F7>", ":lua require'dap'.step_into()<CR>" }
nnoremap { "<F8>", ":lua require'dap'.step_out()<CR>" }

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

local dapui = require "dapui"
dap.listeners.after.event_initialized["dapui_config"] = function()
	vim.cmd "tab split" -- TODO: open/close new tab with dapui layout
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
