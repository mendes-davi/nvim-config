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
	spaces = function()
		return "spaces:" .. vim.api.nvim_buf_get_option(0, "shiftwidth")
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

-- stylua: ignore
local colors  = {
	bg        = "#007acc",
	black     = "#181a1c",
	yellow    = "#edc763",
	cyan      = "#89b482",
	oceanblue = "#45707a",
    green     = "#6a9955",
	orange    = "#f89860",
	violet    = "#d3869b",
	magenta   = "#c14a4a",
	fg        = "#e1e3e4",
	skyblue   = "#7daea3",
	red       = "#fb617e",
	grey      = "#5c6370",
}
-- stylua: ignore
local vi_mode_colors = {
	["NORMAL"]    = "grey",
	["OP"]        = "green",
	["INSERT"]    = "bg",
	["VISUAL"]    = "skyblue",
	["LINES"]     = "skyblue",
	["BLOCK"]     = "skyblue",
	["REPLACE"]   = "violet",
	["V-REPLACE"] = "violet",
	["ENTER"]     = "cyan",
	["MORE"]      = "cyan",
	["SELECT"]    = "orange",
	["COMMAND"]   = "green",
	["SHELL"]     = "green",
	["TERM"]      = "green",
	["NONE"]      = "yellow",
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
			val.fg = "fg"
			return val
		end,
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
			fg = "fg",
			bg = "bg",
			style = "bold",
		},
		right_sep = " ",
	},
	-- gitBranch
	git_branch = {
		provider = "git_branch",
		hl = {
			fg = "fg",
			bg = "bg",
			style = "bold",
		},
		left_sep = " ",
	},
	-- diffAdd
	git_diff_added = {
		provider = "git_diff_added",
		hl = {
			fg = "fg",
			bg = "bg",
		},
	},
	-- diffModfified
	git_diff_changed = {
		provider = "git_diff_changed",
		hl = {
			fg = "fg",
			bg = "bg",
		},
	},
	-- diffRemove
	git_diff_removed = {
		provider = "git_diff_removed",
		hl = {
			fg = "fg",
			bg = "bg",
		},
		right_sep = " ",
	},
	-- spellLang
	spelllang = {
		enabled = function()
			return vim.wo.spell and checkwidth()
		end,
		provider = " " .. vim.o.spelllang:upper(),
		hl = {
			fg = "fg",
			bg = "bg",
		},
		right_sep = " ",
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
			fg = "fg",
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
			fg = "fg",
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
			fg = "fg",
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
			fg = "fg",
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
			fg = "fg",
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
	-- textFormat
	text_format = {
		provider = "spaces",
		enabled = checkwidth,
		hl = {
			fg = "fg",
		},
		right_sep = " ",
	},
	-- fileType
	file_type = {
		provider = "file_type",
		enabled = checkwidth,
		hl = {
			fg = "fg",
		},
		left_sep = " ",
		right_sep = " ",
	},
	-- fileFormat
	file_format = {
		provider = "file_format_icon",
		enabled = function()
			return vim.bo.fileformat:upper() ~= "UNIX"
		end,
		hl = {
			fg = "fg",
			bg = "bg",
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
			fg = "fg",
			bg = "bg",
		},
		right_sep = " ",
	},
	-- lineInfo
	line_info = {
		provider = "position",
		enabled = checkwidth,
		hl = {
			fg = "fg",
			bg = "bg",
		},
		right_sep = " ",
	},
	-- linePercent
	line_percentage = {
		provider = "line_percentage",
		enabled = checkwidth,
		hl = {
			fg = "fg",
			bg = "bg",
		},
		right_sep = " ",
	},
	-- scrollBar
	scroll_bar = {
		provider = "scroll_bar",
		enabled = checkwidth,
		hl = {
			fg = "fg",
			bg = "bg",
		},
	},

	-- INACTIVE
	inactive_filetype = {
		provider = "file_type",
		hl = {
			fg = "fg",
			bg = "cyan",
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
			my.git_branch,
			my.diagnostic_errors,
			my.diagnostic_warnings,
			my.diagnostics_hints,
			my.diagnostic_infos,
		},
		{
			my.file_info,
			my.lsp_progress,
		},
		{
			my.git_diff_added,
			my.git_diff_changed,
			my.git_diff_removed,
			my.spelllang,
			my.file_format,
			my.file_encoding,
			-- my.text_format,
			my.file_type,
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
	vi_mode_colors = vi_mode_colors,
	components = components,
	custom_providers = custom_providers,
	force_inactive = force_inactive,
}
