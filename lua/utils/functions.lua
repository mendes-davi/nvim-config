local M = {}

M.toggle_qf = function()
	local qf_open = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_open = true
		end
	end
	if qf_open == true then
		vim.cmd "cclose"
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd "copen"
		if vim.b.bqf_enabled or false then
			vim.api.nvim_feedkeys([['"]], "im", false)
		end
	else
		vim.notify("is empty.", vim.log.levels.INFO, { title = "QF - Toggle" })
	end
end

M.toggle_opt = function(opt_t, id)
	return function()
		if vim[opt_t][id] then
			vim[opt_t][id] = false
		else
			vim[opt_t][id] = true
		end
	end
end

M.toggle_diagnostics_loclist = function()
	local loc = vim.fn.getloclist(0)
	if loc and type(loc) == "table" and #loc > 0 then
		-- close the loclist
		vim.api.nvim_command "lclose"
		-- clear the loclist
		vim.fn.setloclist(0, {})
		return
	end

	local diag = vim.diagnostic.get(0, { severity_limit = vim.diagnostic.severity.WARN })
	if diag and type(diag) == "table" and #diag > 0 then
		vim.diagnostic.setloclist { severity_limit = vim.diagnostic.severity.WARN }
	else
		vim.notify("no diagnostics meet the severity level >= warn.", vim.log.levels.INFO, { title = "QF - Diagnostics" })
	end
end

local diagnostics_active = true
M.toggle_diagnostics = function()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

return M
