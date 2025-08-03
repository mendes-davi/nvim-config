local icon = {
	git = {
		LineAdded = "",
		LineModified = "",
		LineRemoved = "",
		LineLeft = "▎",
		LineMiddle = "│",
	},
	diagnostics = {
		Error = " ",
		Warning = " ",
		Info = " ",
		Hint = " ",
	},
	spinner = { "", "", "", "", "", "", "", "", "", "", "", "", "" },
	dap = {
		Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = "󰮔 ",
	},
}

local lualine = require "lualine"

local filetype = { "filetype", padding = 0, icon_only = true, component_separators = { left = "", right = "" } }

local checkwidth = function()
	local squeeze_width
	if vim.o.laststatus == 3 then
		squeeze_width = vim.o.columns / 2
	else
		squeeze_width = vim.api.nvim_win_get_width(0) / 2
	end

	if squeeze_width > 50 then
		return true
	end
	return false
end

local spell = {
	cond = function()
		return vim.wo.spell and checkwidth()
	end,
	function()
		return vim.o.spelllang:upper()
	end,
	icon = "",
}

local lsp_status = {
	"lsp_status",
	icon = "", -- f013
	symbols = {
		spinner = icon.spinner,
		done = false,
		separator = " ",
	},
	fmt = function(str)
		return str:upper()
	end,
	cond = checkwidth,
	-- List of LSP names to ignore (e.g., `null-ls`):
	ignore_lsp = {},
}

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = {
		error = icon.diagnostics.Error,
		hint = icon.diagnostics.Hint,
		info = icon.diagnostics.Info,
		warn = icon.diagnostics.Warning,
	},
	colored = true,
	update_in_insert = true,
	always_visible = false,
	cond = checkwidth,
}

local diff = {
	"diff",
	source = function()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end,
	symbols = {
		added = icon.git.LineAdded .. " ",
		modified = icon.git.LineModified .. " ",
		removed = icon.git.LineRemoved .. " ",
	},
	colored = true,
	always_visible = false,
	cond = checkwidth,
}

lualine.setup {
	options = {
		theme = "everforest",
		globalstatus = true,
		disabled_filetypes = { "lazy", "NvimTree" },
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		-- section_separators = { left = "", right = "" },
		-- component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = {
			function()
				local mode = vim.api.nvim_get_mode()["mode"]
				return "" .. string.format("%-1s", mode):upper()
			end,
		},
		lualine_b = { { "branch", icon = "" }, diff, diagnostics },
		lualine_c = {
			{ "%=", component_separators = { left = "", right = "" } },
			filetype,
			{ "filename", path = 1, symbols = { modified = "●", readonly = "🔒", unamed = "" }, component_separators = { left = "", right = "" } },
		},
		lualine_x = {
			spell,
			lsp_status,
			{
				"encoding",
				fmt = function(str)
					return str:upper()
				end,
				cond = checkwidth,
			},
			{ "fileformat", cond = checkwidth },
		},
		lualine_y = { { "progress", cond = checkwidth } },
		lualine_z = { "location" },
	},
}
