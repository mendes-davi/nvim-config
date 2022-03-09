nnoremap { "<F5>", ":lua require'dap'.continue()<CR>" }
nnoremap { "<F6>", ":lua require'dap'.step_over()<CR>" }
nnoremap { "<F7>", ":lua require'dap'.step_into()<CR>" }
nnoremap { "<F8>", ":lua require'dap'.step_out()<CR>" }
nnoremap { "<leader>bp", ":lua require'dap'.toggle_breakpoint()<CR>" }
nnoremap { "<leader>bc", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" }
nnoremap { "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>" }
nnoremap { "<leader>dr", ":lua require'dap'.repl.open()<CR>" }
nnoremap { "<leader>dl", ":lua require'dap'.run_last()<CR>" }

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

require("dap.python").setup "/home/davi/.local/miniconda3/bin/python"
require("dap.python").test_runner = "pytest"
nnoremap {"<leader>dn", ":lua require('dap.python').test_method()<CR>", silent = true}
nnoremap {"<leader>df", ":lua require('dap.python').test_class()<CR>", silent = true}
vnoremap {"<leader>ds", "<ESC>:lua require('dap.python').debug_selection()<CR>", silent = true}

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

local dapui = require("dapui")
-- dap.listeners.after.event_initialized["dapui_config"] = function()
  -- dapui.open()
-- end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
