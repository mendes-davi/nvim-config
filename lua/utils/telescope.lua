local M = {}

M.generate_offset = function(str, tabsize)
	local offset = (tabsize - vim.fn.strdisplaywidth(str) % tabsize) % tabsize
	return string.rep(" ", offset)
end

M.generate_display = function(pieces)
	local res_text = ""
	local res_highlight = {}
	for _, piece in ipairs(pieces) do
		local text, highlight = unpack(piece)
		if highlight ~= nil then
			table.insert(res_highlight, { { #res_text, #res_text + #text }, highlight })
		end
		res_text = res_text .. text
	end
	return res_text, res_highlight
end

M.refine_filename = function(filename, cwd)
	if cwd ~= nil then
		cwd = vim.loop.cwd()
	end
	local relative_filename = require("plenary.path"):new(filename):make_relative(cwd)
	local name = relative_filename:match "[^/]*$"
	local dir = relative_filename:match "^.*/" or ""
	local icon, hl_icon = require("telescope.utils").transform_devicons(filename)
	icon = icon .. M.generate_offset(icon, 3)
	return { icon, hl_icon }, { dir, "TelescopeResultsSpecialComment" }, { name }
end

M.lsp_entry_maker = function(entry)
	local res = require("telescope.make_entry").gen_from_quickfix()(entry)
	res.display = function(entry_tbl)
		local icon, dir, name = M.refine_filename(entry_tbl.filename)
		local pos = " " .. entry_tbl.lnum .. ":" .. entry_tbl.col
		local offset = M.generate_offset(icon[1] .. dir[1] .. name[1] .. pos .. "  ", 10)
		local trimmed_text = entry_tbl.text:gsub("^%s*(.-)%s*$", "%1")
		return M.generate_display {
			icon,
			dir,
			name,
			{ pos, "TelescopeResultsLineNr" },
			{ offset .. trimmed_text },
		}
	end
	return res
end

M.files_entry_maker = function(entry)
	local res = require("telescope.make_entry").gen_from_file()(entry)
	res.display = function(entry_tbl)
		return M.generate_display { M.refine_filename(entry_tbl[1]) }
	end
	return res
end

M.grep_entry_maker = function(entry)
	local res = require("telescope.make_entry").gen_from_vimgrep()(entry)
	res.display = function(entry_tbl)
		local _, _, filename, pos, text = string.find(entry_tbl[1], "^(.*):(%d+:%d+):(.*)$")
		local icon, dir, name = M.refine_filename(filename)
		local offset = M.generate_offset(icon[1] .. dir[1] .. name[1] .. " " .. pos .. "  ", 10)
		return M.generate_display { icon, dir, name, { " " .. pos, "TelescopeResultsLineNr" }, { offset .. text } }
	end
	return res
end

M.buffers_entry_maker = function(entry)
	local res = require("telescope.make_entry").gen_from_buffer()(entry)
	res.display = function(entry_tbl)
		local icon, dir, name = M.refine_filename(entry_tbl.filename)
		local offset = M.generate_offset(tostring(entry_tbl.bufnr), 4)
		return M.generate_display {
			{ tostring(entry_tbl.bufnr) .. offset, "TelescopeResultsNumber" },
			{ entry_tbl.indicator, "TelescopeResultsComment" },
			icon,
			dir,
			name,
			{ " " .. tostring(entry_tbl.lnum), "TelescopeResultsLineNr" },
		}
	end
	return res
end

M.diagnostics_entry_maker = function(entry)
	local res = require("telescope.make_entry").gen_from_diagnostics()(entry)
	res.display = function(entry_tbl)
		local sign = vim.fn.sign_getdefined("DiagnosticSign" .. entry_tbl.type:lower():gsub("^%l", string.upper))[1]
		local signature = sign.text .. " " .. entry_tbl.lnum .. ":" .. entry_tbl.col .. " "
		local icon, dir, name = M.refine_filename(entry_tbl.filename)
		local trimmed_text = entry_tbl.text:gsub("^%s*(.-)%s*$", "%1")
		return M.generate_display {
			{ signature .. M.generate_offset(signature, 11), sign.texthl },
			icon,
			dir,
			name,
			{ ": " .. trimmed_text },
		}
	end
	return res
end

return M
