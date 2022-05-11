-- vim: foldlevel=1
local lsp = require "feline.providers.lsp"
local vi_mode_utils = require "feline.providers.vi_mode"
local severity = vim.diagnostic.severity

local custom_providers = {
	lsp_progress = function()
		return #vim.lsp.buf_get_clients() > 0 and require("lsp").lsp_progress() or ""
	end,
	lsp_client_offset_encoding = function()
		local clients = {}
		for _, client in pairs(vim.lsp.buf_get_clients(0)) do
			clients[#clients + 1] = client.name .. ":" .. client.offset_encoding
		end
		return table.concat(clients, ", "), "🗲 "
	end,
	file_format_icon = function()
		local icons = {
			UNIX = "",
			MAC = "",
			DOS = "",
		}
		local os = vim.bo.fileformat:upper()
		return icons[os] .. " " .. os
	end,
}

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 50 then
		return true
	end
	return false
end

local force_inactive = {
	filetypes = {
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
		"dapui_watches",
		"dapui_stacks",
		"dapui_breakpoints",
		"dapui_scopes",
		"vista_kind",
	},
	buftypes = {
		"terminal",
		"prompt",
	},
	bufnames = {},
}

-- TODO: Feline colors for everforest
local configuration = vim.fn["sonokai#get_configuration"]()
local palette = vim.fn["sonokai#get_palette"](configuration.style, configuration.colors_override)
-- local configuration = vim.fn['everforest#get_configuration']()
-- local palette = vim.fn['everforest#get_palette'](configuration.background)
if configuration.transparent_background == 1 then
	palette.bg1 = palette.none
end

local colors = {
	bg = palette.bg2[1],
	black = palette.black[1],
	yellow = palette.yellow[1],
	cyan = "#89b482",
	oceanblue = "#45707a",
	green = palette.green[1],
	orange = palette.orange[1],
	violet = "#d3869b",
	magenta = "#c14a4a",
	white = "#a89984",
	fg = palette.fg[1],
	skyblue = "#7daea3",
	red = palette.red[1],
	grey = palette.grey[1],
}

local vi_mode_colors = {
	["NORMAL"] = "grey",
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

local my = {
	-- LEFT
	-- vi-mode
	vi_mode = {
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
	},
	-- vi-symbol
	vi_symbol = {
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
	},
	-- filename
	file_info = {
		provider = {
			name = "file_info",
			opts = {
				type = "short-path",
				file_readonly_icon = "  ",
				file_modified_icon = "",
			},
		},
		short_provider = {
			name = "file_info",
			opts = {
				type = "base-only",
			},
		},
		hl = {
			fg = "white",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- gitBranch
	git_branch = {
		provider = "git_branch",
		hl = {
			fg = "yellow",
			bg = "bg",
			style = "bold",
		},
		right_sep = "",
	},
	-- diffAdd
	git_diff_added = {
		provider = "git_diff_added",
		hl = {
			fg = "green",
			bg = "bg",
			style = "bold",
		},
	},
	-- diffModfified
	git_diff_changed = {
		provider = "git_diff_changed",
		hl = {
			fg = "orange",
			bg = "bg",
			style = "bold",
		},
	},
	-- diffRemove
	git_diff_removed = {
		provider = "git_diff_removed",
		hl = {
			fg = "red",
			bg = "bg",
			style = "bold",
		},
	},
	-- spellLang
	spelllang = {
		provider = ' %{&spell?&spelllang:""} ',
		hl = {
			fg = "green",
			bg = "bg",
			style = "bold",
		},
	},

	-- MID
	-- LspName
	lsp_client_with_offset = {
		-- provider = "lsp_client_names",
		provider = "lsp_client_offset_encoding",
		enabled = checkwidth,
		hl = {
			fg = "yellow",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	lsp_progress = {
		provider = "lsp_progress",
		enabled = checkwidth,
		hl = {
			fg = "yellow",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- diagnosticErrors
	diagnostic_errors = {
		provider = "diagnostic_errors",
		enabled = function()
			return lsp.diagnostics_exist(severity.ERROR)
		end,
		hl = {
			fg = "red",
			style = "bold",
		},
	},
	-- diagnosticWarn
	diagnostic_warnings = {
		provider = "diagnostic_warnings",
		enabled = function()
			return lsp.diagnostics_exist(severity.WARN)
		end,
		hl = {
			fg = "yellow",
			style = "bold",
		},
	},
	-- diagnosticHint
	diagnostics_hints = {
		provider = "diagnostic_hints",
		enabled = function()
			return lsp.diagnostics_exist(severity.HINT)
		end,
		hl = {
			fg = "cyan",
			style = "bold",
		},
	},
	-- diagnosticInfo
	diagnostic_infos = {
		provider = "diagnostic_info",
		enabled = function()
			return lsp.diagnostics_exist(severity.INFO)
		end,
		hl = {
			fg = "skyblue",
			style = "bold",
		},
	},

	-- RIGHT
	-- fileSize
	file_size = {
		provider = "file_size",
		enabled = function()
			return vim.fn.getfsize(vim.fn.expand "%:t") > 0
		end,
		hl = {
			fg = "skyblue",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- fileFormat
	file_format = {
		provider = "file_format_icon",
		enabled = function()
			return vim.bo.fileformat:upper() ~= "UNIX"
		end,
		hl = {
			fg = "skyblue",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- fileEncode
	file_encoding = {
		provider = "file_encoding",
		enabled = function()
			return vim.bo.fileencoding:upper() ~= "UTF-8"
		end,
		hl = {
			fg = "skyblue",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- lineInfo
	line_info = {
		provider = "position",
		enabled = checkwidth,
		hl = {
			fg = "white",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- linePercent
	line_percentage = {
		provider = "line_percentage",
		enabled = checkwidth,
		hl = {
			fg = "white",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- scrollBar
	scroll_bar = {
		provider = "scroll_bar",
		enabled = checkwidth,
		hl = {
			fg = "yellow",
			bg = "bg",
		},
	},

	-- INACTIVE
	inactive_filetype = {
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
	},
}

-- Initialize the components table
local components = {
	active = {
		{
			my.vi_mode,
			my.vi_symbol,
			my.file_info,
			my.git_branch,
			my.git_diff_added,
			my.git_diff_changed,
			my.git_diff_removed,
			my.spelllang,
		},
		{
			my.lsp_client_with_offset,
			my.lsp_progress,
			my.diagnostic_errors,
			my.diagnostic_warnings,
			my.diagnostics_hints,
			my.diagnostic_infos,
		},
		{
			-- my.file_size,
			my.file_format,
			my.file_encoding,
			my.line_info,
			my.line_percentage,
			my.scroll_bar,
		},
	},
	inactive = {
		{
			my.inactive_filetype,
		},
	},
}

require("feline").setup {
	theme = colors,
	default_bg = colors.bg,
	default_fg = colors.fg,
	vi_mode_colors = vi_mode_colors,
	components = components,
	custom_providers = custom_providers,
	force_inactive = force_inactive,
}

-- https://github.com/etrnal70/ditsdots/blob/master/.config/nvim/lua/config/autocmds.lua
-- Disable Feline on CmdlineEnter
local prev_laststatus = vim.o.laststatus
vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = "*",
	callback = function()
		prev_laststatus = vim.o.laststatus
		vim.o.laststatus = 0
		vim.opt.statusline = " "
		if prev_laststatus == 2 then
			vim.cmd "hi StatusLineNC guibg=NONE"
		end
		vim.cmd "redraws"
	end,
})
-- Enable Feline on CmdlineLeave
vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = "*",
	callback = function()
		vim.o.laststatus = prev_laststatus
		vim.opt.statusline = "%{%v:lua.require'feline'.statusline()%}"
	end,
})
