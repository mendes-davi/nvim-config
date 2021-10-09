local lsp = require "feline.providers.lsp"
local vi_mode_utils = require "feline.providers.vi_mode"

custom_providers = {
	lsp_progress = function()
		return #vim.lsp.buf_get_clients() > 0 and require("lsp").lsp_progress() or ""
	end,
}

local force_inactive = {
	filetypes = {},
	buftypes = {},
	bufnames = {},
}

-- Initialize the components table
local components = {
	active = {},
	inactive = {},
}

-- Insert three sections (left, mid and right) for the active statusline
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

-- Insert two sections (left and right) for the inactive statusline
table.insert(components.inactive, {})
table.insert(components.inactive, {})

local colors = {
	bg = "#2d2a2e",
	black = "#343136",
	yellow = "#ffd866",
	cyan = "#89b482",
	oceanblue = "#45707a",
	green = "#a9dc76",
	orange = "#e78a4e",
	violet = "#d3869b",
	magenta = "#c14a4a",
	white = "#a89984",
	fg = "#e3e1e4",
	skyblue = "#7daea3",
	red = "#ff6188",
}

local vi_mode_colors = {
	["NORMAL"] = "green",
	["OP"] = "green",
	["INSERT"] = "red",
	["VISUAL"] = "skyblue",
	["LINES"] = "skyblue",
	["BLOCK"] = "skyblue",
	["REPLACE"] = "violet",
	["V-REPLACE"] = "violet",
	["ENTER"] = "cyan",
	["MORE"] = "cyan",
	["SELECT"] = "orange",
	["COMMAND"] = "green",
	["SHELL"] = "green",
	["TERM"] = "green",
	["NONE"] = "yellow",
}

local vi_mode_text = {
	["NORMAL"] = "<|",
	["OP"] = "<|",
	["INSERT"] = "|>",
	["VISUAL"] = "<>",
	["LINES"] = "--",
	["BLOCK"] = "<>",
	["REPLACE"] = "<>",
	["V-REPLACE"] = "<>",
	["ENTER"] = "<>",
	["MORE"] = "<>",
	["SELECT"] = "<>",
	["COMMAND"] = "<|",
	["SHELL"] = "<|",
	["TERM"] = "<|",
	["NONE"] = "<>",
}

local buffer_not_empty = function()
	if vim.fn.empty(vim.fn.expand "%:t") ~= 1 then
		return true
	end
	return false
end

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then
		return true
	end
	return false
end

force_inactive.filetypes = {
	"NvimTree",
	"dbui",
	"packer",
	"startify",
	"fugitive",
	"fugitiveblame",
	"qf",
	"help",
	"Trouble",
	"DiffviewFiles",
}

force_inactive.buftypes = {
	"terminal",
}

-- LEFT
-- vi-mode
components.active[1][1] = {
	provider = function()
		return " " .. vi_mode_utils.get_vim_mode() .. " "
	end,
	hl = function()
		local val = {}

		val.bg = vi_mode_utils.get_mode_color()
		val.fg = "black"
		val.style = "bold"

		return val
	end,
	right_sep = "",
}

-- vi-symbol
components.active[1][2] = {
	provider = function()
		return vi_mode_text[vi_mode_utils.get_vim_mode()] or ""
	end,
	hl = function()
		local val = {}
		val.fg = vi_mode_utils.get_mode_color()
		val.bg = "bg"
		val.style = "bold"
		return val
	end,
	right_sep = " ",
}
-- filename
components.active[1][3] = {
	provider = "file_info",
	type = "unique",
	hl = {
		fg = "white",
		bg = "bg",
		style = "bold",
	},
	right_sep = "",
}

-- gitBranch
components.active[1][4] = {
	provider = "git_branch",
	hl = {
		fg = "yellow",
		bg = "bg",
		style = "bold",
	},
}
-- diffAdd
components.active[1][5] = {
	provider = "git_diff_added",
	hl = {
		fg = "green",
		bg = "bg",
		style = "bold",
	},
}
-- diffModfified
components.active[1][6] = {
	provider = "git_diff_changed",
	hl = {
		fg = "orange",
		bg = "bg",
		style = "bold",
	},
}
-- diffRemove
components.active[1][7] = {
	provider = "git_diff_removed",
	hl = {
		fg = "red",
		bg = "bg",
		style = "bold",
	},
}

components.active[1][8] = {
	provider = ' %{&spell?&spelllang:""} ',
	hl = {
		fg = "green",
		bg = "bg",
		style = "bold",
	},
}

-- MID
-- LspName
components.active[2][1] = {
	provider = "lsp_client_names",
	enabled = checkwidth,
	hl = {
		fg = "yellow",
		bg = "bg",
		style = "bold",
	},
	right_sep = " ",
}
components.active[2][2] = {
	provider = "lsp_progress",
	enabled = checkwidth,
	hl = {
		fg = "yellow",
		bg = "bg",
		style = "bold",
	},
	right_sep = " ",
}
-- diagnosticErrors
components.active[2][3] = {
	provider = "diagnostic_errors",
	enabled = function()
		return lsp.diagnostics_exist "Error"
	end,
	hl = {
		fg = "red",
		style = "bold",
	},
}
-- diagnosticWarn
components.active[2][4] = {
	provider = "diagnostic_warnings",
	enabled = function()
		return lsp.diagnostics_exist "Warning"
	end,
	hl = {
		fg = "yellow",
		style = "bold",
	},
}
-- diagnosticHint
components.active[2][5] = {
	provider = "diagnostic_hints",
	enabled = function()
		return lsp.diagnostics_exist "Hint"
	end,
	hl = {
		fg = "cyan",
		style = "bold",
	},
}
-- diagnosticInfo
components.active[2][6] = {
	provider = "diagnostic_info",
	enabled = function()
		return lsp.diagnostics_exist "Information"
	end,
	hl = {
		fg = "skyblue",
		style = "bold",
	},
}

-- RIGHT

-- -- fileIcon
-- components.active[3][1] = {
-- 	provider = function()
-- 		local filename = vim.fn.expand "%:t"
-- 		local extension = vim.fn.expand "%:e"
-- 		local icon = require("nvim-web-devicons").get_icon(filename, extension)
-- 		if icon == nil then
-- 			icon = ""
-- 		end
-- 		return icon
-- 	end,
-- 	hl = function()
-- 		local val = {}
-- 		local filename = vim.fn.expand "%:t"
-- 		local extension = vim.fn.expand "%:e"
-- 		local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
-- 		if icon ~= nil then
-- 			val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
-- 		else
-- 			val.fg = "white"
-- 		end
-- 		val.bg = "bg"
-- 		val.style = "bold"
-- 		return val
-- 	end,
-- 	right_sep = " ",
-- }

-- -- fileType
-- components.active[3][2] = {
-- 	provider = "file_type",
-- 	hl = function()
-- 		local val = {}
-- 		local filename = vim.fn.expand "%:t"
-- 		local extension = vim.fn.expand "%:e"
-- 		local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
-- 		if icon ~= nil then
-- 			val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
-- 		else
-- 			val.fg = "white"
-- 		end
-- 		val.bg = "bg"
-- 		val.style = "bold"
-- 		return val
-- 	end,
-- 	right_sep = " ",
-- }

-- -- fileSize
-- components.active[3][3] = {
-- 	provider = "file_size",
-- 	enabled = function()
-- 		return vim.fn.getfsize(vim.fn.expand "%:t") > 0
-- 	end,
-- 	hl = {
-- 		fg = "skyblue",
-- 		bg = "bg",
-- 		style = "bold",
-- 	},
-- 	right_sep = " ",
-- }

-- -- fileFormat
-- components.active[3][4] = {
-- 	provider = function()
-- 		return "" .. vim.bo.fileformat:upper() .. ""
-- 	end,
-- 	hl = {
-- 		fg = "white",
-- 		bg = "bg",
-- 		style = "bold",
-- 	},
-- 	right_sep = " ",
-- }
-- -- fileEncode
-- components.active[3][5] = {
-- 	provider = "file_encoding",
-- 	hl = {
-- 		fg = "white",
-- 		bg = "bg",
-- 		style = "bold",
-- 	},
-- 	right_sep = " ",
-- }

-- lineInfo
components.active[3][1] = {
	provider = "position",
	enabled = checkwidth,
	hl = {
		fg = "white",
		bg = "bg",
		style = "bold",
	},
	right_sep = " ",
}
-- linePercent
components.active[3][2] = {
	provider = "line_percentage",
	enabled = checkwidth,
	hl = {
		fg = "white",
		bg = "bg",
		style = "bold",
	},
	right_sep = " ",
}
-- scrollBar
components.active[3][3] = {
	provider = "scroll_bar",
	enabled = checkwidth,
	hl = {
		fg = "yellow",
		bg = "bg",
	},
}

-- INACTIVE

-- fileType
components.inactive[1][1] = {
	provider = "file_type",
	hl = {
		fg = "black",
		bg = "cyan",
		style = "bold",
	},
	left_sep = {
		str = " ",
		hl = {
			fg = "NONE",
			bg = "cyan",
		},
	},
	right_sep = {
		{
			str = " ",
			hl = {
				fg = "NONE",
				bg = "cyan",
			},
		},
		" ",
	},
}

require("feline").setup {
	colors = colors,
	default_bg = bg,
	default_fg = fg,
	vi_mode_colors = vi_mode_colors,
	components = components,
	custom_providers = custom_providers,
	force_inactive = force_inactive,
}
