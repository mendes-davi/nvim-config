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
		vim.notify("[QF] - is empty", vim.log.levels.INFO)
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

return M
