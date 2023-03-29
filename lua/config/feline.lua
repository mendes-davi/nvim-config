-- vim: foldlevel=2
local lsp = require "feline.providers.lsp"
local vi_mode_utils = require "feline.providers.vi_mode"
local severity = vim.diagnostic.severity
local diagnostic = vim.diagnostic

vim.opt.fillchars:append "stl:─,stlnc:─"

-- stylua: ignore
local colors = {
	bg          = "#312c2b",
	black       = "#1f1e1c",
	bg_dim      = "#242120",
	bg0         = "#312c2b",
	bg1         = "#393230",
	bg2         = "#413937",
	bg3         = "#49403c",
	bg4         = "#4e433f",
	bg_red      = "#fd6883",
	diff_red    = "#55393d",
	bg_green    = "#adda78",
	diff_green  = "#394634",
	bg_blue     = "#85dad2",
	diff_blue   = "#354157",
	diff_yellow = "#4e432f",
	fg          = "#e4e3e1",
	red         = "#f86882",
	orange      = "#f08d71",
	yellow      = "#f0c66f",
	green       = "#a6cd77",
	blue        = "#81d0c9",
	purple      = "#9fa0e1",
	grey        = "#90817b",
	grey_dim    = "#6a5e59",
}

local my_highlights = {
	root = { "StatusComponentRootDir", "", colors.grey, colors.bg },
	base = { "StatusComponentBaseDir", "gui=bold,underline", colors.white, colors.bg },
	trunk = { "StatusComponentTrunkDir", "", colors.fg, colors.bg },
}
for _, val in pairs(my_highlights) do
	vim.cmd(string.format("highlight clear %s", val[1]))
	vim.cmd(string.format("highlight %s %s guifg=%s guibg=%s", val[1], val[2], val[3], val[4]))
end

local function diagnostics(sev)
	local count = lsp.get_diagnostics_count(sev)
	return count ~= 0 and tostring(count) or ""
end

local custom_providers = {
	diag_errors = function()
		return diagnostics(severity.ERROR)
	end,
	diag_warnings = function()
		return diagnostics(severity.WARN)
	end,

	diag_info = function()
		return diagnostics(severity.INFO)
	end,

	diag_hints = function()
		return diagnostics(severity.HINT)
	end,

	my_file_info = function(_, opts)
		local cur_path = vim.fn.expand "%:p"
		local home = vim.fs.find(opts.names, {
			path = cur_path,
			upward = true,
		})[1]

		local root, trunk, icon
		if home == nil then
			local cwd = vim.fn.expand "%:p:~:h"
			local file = vim.fn.expand("%:p:~"):gsub(cwd .. "/", "")
			root = table.concat { "%#StatusComponentRootDir#", cwd, "/", "%*" }
			trunk = table.concat { "%#StatusComponentTrunkDir#", file }
		else
			home = vim.fn.fnamemodify(vim.fs.dirname(home), ":~:.")
			root = table.concat { "%#StatusComponentRootDir#", vim.fs.dirname(home), "/", "%*" }
			trunk = table.concat {
				"%#StatusComponentBaseDir#",
				vim.fs.basename(home),
				"/",
				"%*",
				"%#StatusComponentTrunkDir#",
				vim.fn.expand "%r",
			}
		end

		-- Icon
		local icon_str, icon_color = require("nvim-web-devicons").get_icon_color(
			vim.fn.expand "%:t",
			nil, -- extension is already computed by nvim-web-devicons
			{ default = true }
		)
		icon = { str = icon_str .. " " }
		if opts.colored_icon ~= false then
			icon.hl = { fg = icon_color }
		end

		return root .. trunk, icon
	end,
}

local my_diag_sep = function(sev, sep)
	return function()
		if vim.tbl_count(diagnostic.get(0, { severity = { max = sev } })) > 0 then
			return sep or " "
		else
			return ""
		end
	end
end

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
local vi_mode_colors = {
	["NORMAL"]    = "grey",
	["OP"]        = "green",
	["INSERT"]    = "bg",
	["VISUAL"]    = "diff_blue",
	["LINES"]     = "diff_blue",
	["BLOCK"]     = "diff_blue",
	["REPLACE"]   = "purple",
	["V-REPLACE"] = "purple",
	["ENTER"]     = "green",
	["MORE"]      = "green",
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

local sep = {
	left = "left_rounded",
	right = "right_rounded",
	hl = {
		fg = "bg",
		bg = "Normal",
	},
}

local my = {
	gap = { hl = { fg = "grey", bg = "Normal" } },
	left_sep = { str = sep.left, hl = sep.hl },
	right_sep = { str = sep.right, hl = sep.hl },

	sep = function(tbl, cfg)
		local my_cmp = tbl or {}
		local border = cfg or "both"
		local left_sep = {
			left_sep = { str = sep.left, hl = sep.hl },
		}
		local right_sep = {
			right_sep = { str = sep.right, hl = sep.hl },
		}
		local cmp, sel_sep
		if type(border) == "string" then
			if border == "both" then
				sel_sep = vim.tbl_extend("error", left_sep, right_sep)
			elseif border == "left" then
				sel_sep = left_sep
			elseif border == "right" then
				sel_sep = right_sep
			else
				sel_sep = {}
			end
		else
			sel_sep = border
		end
		cmp = vim.tbl_extend("force", my_cmp, sel_sep)
		return cmp
	end,

	dap_status = {
		provider = function()
			return require("dap").status()
		end,
		enable = function()
			return require("dap").session() ~= nil and checkwidth()
		end,
		icon = {
			str = " ",
			hl = { fg = "red", bg = "bg" },
		},
		hl = {
			fg = "fg",
			bg = "bg",
		},
	},

	-- LEFT
	-- vi-mode
	vi_mode = {
		provider = function()
			return " " .. vi_mode_utils.get_vim_mode()
		end,
		hl = function()
			return {
				fg = "fg",
				bg = vi_mode_utils.get_mode_color(),
			}
		end,
		right_sep = {
			str = sep.right,
			hl = function()
				return {
					fg = vi_mode_utils.get_mode_color(),
					bg = sep.hl.bg,
				}
			end,
		},
	},
	-- filename
	file_info = {
		provider = {
			name = "my_file_info",
			opts = {
				names = { ".git", "Makefile" },
				type = "full-path",
				file_readonly_icon = "  ",
				file_modified_icon = "",
			},
		},
		short_provider = {
			name = "file_info",
			opts = {
				type = "short-path",
			},
		},
		hl = {
			fg = "fg",
			bg = "bg",
		},
	},
	-- gitBranch
	git_branch = {
		provider = "git_branch",
		hl = {
			fg = "yellow",
			bg = "bg",
		},
	},
	-- diffAdd
	git_diff_added = {
		provider = "git_diff_added",
		hl = {
			fg = "green",
			bg = "bg",
		},
	},
	-- diffModfified
	git_diff_changed = {
		provider = "git_diff_changed",
		hl = {
			fg = "blue",
			bg = "bg",
		},
	},
	-- diffRemove
	git_diff_removed = {
		provider = "git_diff_removed",
		hl = {
			fg = "red",
			bg = "bg",
		},
	},
	-- spellLang
	spelllang = {
		enabled = function()
			return vim.wo.spell and checkwidth()
		end,
		provider = function()
			return vim.o.spelllang:upper()
		end,
		hl = {
			fg = "fg",
			bg = "bg",
		},
		icon = { str = " ", hl = { fg = "orange" } },
		right_sep = " ",
	},

	-- MID
	-- diagnosticErrors
	diagnostic_errors = {
		provider = "diag_errors",
		icon = { str = " ", hl = { fg = "red" } },
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
		provider = "diag_warnings",
		icon = { str = " ", hl = { fg = "yellow" } },
		enabled = function()
			return lsp.diagnostics_exist(severity.WARN)
		end,
		hl = {
			fg = "fg",
		},
	},
	-- diagnosticHint
	diagnostic_hints = {
		provider = "diag_hints",
		icon = { str = " ", hl = { fg = "green" } },
		enabled = function()
			return lsp.diagnostics_exist(severity.HINT)
		end,
		hl = {
			fg = "fg",
		},
	},
	-- diagnosticInfo
	diagnostic_infos = {
		provider = "diag_info",
		icon = { str = " ", hl = { fg = "fg" } },
		enabled = function()
			return lsp.diagnostics_exist(severity.INFO)
		end,
		hl = {
			fg = "fg",
		},
	},

	-- RIGHT
	-- fileType
	file_type = {
		provider = {
			name = "file_type",
			opts = {
				filetype_icon = true,
				colored_icon = true,
			},
		},
		hl = {
			fg = "fg",
		},
		enabled = checkwidth,
		right_sep = " ",
	},
	-- fileFormat
	file_format = {
		provider = function()
			return vim.bo.fileformat:upper()
		end,
		icon = {
			str = function()
				local icons = { UNIX = " ", MAC = " ", DOS = " " }
				return icons[vim.bo.fileformat:upper()]
			end,
			hl = { fg = "orange", bg = "bg" },
		},
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
		provider = {
			name = "position",
			opts = {
				padding = true,
			},
		},
		enabled = checkwidth,
		hl = {
			fg = "grey",
			bg = "bg",
		},
		right_sep = " ",
	},
	-- linePercent
	line_percentage = {
		provider = "line_percentage",
		enabled = checkwidth,
		hl = {
			fg = "grey",
			bg = "bg",
		},
		right_sep = " ",
	},
	-- scrollBar
	scroll_bar = {
		provider = "scroll_bar",
		enabled = checkwidth,
		hl = {
			fg = "grey",
			bg = "bg",
		},
	},
}

-- Initialize the components table
local components = {
	active = {
		{
			my.vi_mode,
			my.sep({
				provider = " ",
				enabled = function()
					return require("feline.providers.git").git_info_exists()
				end,
			}, "left"),
			my.git_branch,
			my.git_diff_added,
			my.git_diff_changed,
			my.git_diff_removed,
			my.sep({
				provider = " ",
				enabled = function()
					return require("feline.providers.git").git_info_exists()
				end,
			}, "right"),
			my.sep(my.dap_status, "both"),
			my.gap,
		},
		{
			my.sep(my.file_info, "both"),
			my.sep({
				provider = " ",
				enabled = function()
					return lsp.diagnostics_exist()
				end,
			}, "left"),
			my.sep(my.diagnostic_errors, { right_sep = my_diag_sep(severity.WARNING) }),
			my.sep(my.diagnostic_warnings, { right_sep = my_diag_sep(severity.INFO) }),
			my.sep(my.diagnostic_infos, { right_sep = my_diag_sep(severity.HINT) }),
			my.sep(my.diagnostic_hints, { right_sep = "" }),
			my.sep({
				provider = " ",
				enabled = function()
					return lsp.diagnostics_exist()
				end,
			}, "right"),
			my.gap,
		},
		{
			my.sep(my.file_type, "left"),
			my.spelllang,
			my.file_format,
			my.file_encoding,
			my.line_info,
			my.line_percentage,
			my.scroll_bar,
		},
	},
	inactive = {
		{
			my.gap,
		},
		{
			my.sep(my.file_type, "both"),
			my.gap,
		},
		{},
	},
}

R("feline").setup {
	theme = colors,
	vi_mode_colors = vi_mode_colors,
	components = components,
	custom_providers = custom_providers,
	force_inactive = force_inactive,
}
