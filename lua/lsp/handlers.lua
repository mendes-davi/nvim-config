local lsp = vim.lsp

local notify = require "notify"

lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = {
		severity = { min = vim.diagnostic.severity.INFO },
	},
	-- Enable virtual text only on Warning or above, override spacing to 2
	virtual_text = {
		spacing = 4,
		severity = { min = vim.diagnostic.severity.WARN },
	},
})

lsp.handlers["window/showMessage"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local lvl = ({
		"ERROR",
		"WARN",
		"INFO",
		"DEBUG",
	})[result.type]
	notify({ result.message }, lvl, {
		title = "LSP | " .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == "ERROR" or lvl == "WARN"
		end,
	})
end

-- bordered hover
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
	focusable = true,
})

-- populate qf list with changes (if multiple files modified)
-- NOTE(vir): now using nvim-notify
local function qf_rename()
	local position_params = vim.lsp.util.make_position_params()
	position_params.oldName = vim.fn.expand "<cword>"
	position_params.newName = vim.fn.input("Rename To> ", position_params.oldName)

	vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, result, ...)
		if not result or not result.changes then
			require "notify"(string.format "could not perform rename", "error", {
				title = string.format("[lsp] rename: %s -> %s", position_params.oldName, position_params.newName),
				timeout = 500,
			})

			return
		end

		vim.lsp.handlers["textDocument/rename"](err, result, ...)

		local notification, entries = "", {}
		local num_files, num_updates = 0, 0
		for uri, edits in pairs(result.changes) do
			num_files = num_files + 1
			local bufnr = vim.uri_to_bufnr(uri)

			for _, edit in ipairs(edits) do
				local start_line = edit.range.start.line + 1
				local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

				num_updates = num_updates + 1
				table.insert(entries, {
					bufnr = bufnr,
					lnum = start_line,
					col = edit.range.start.character + 1,
					text = line,
				})
			end

			local short_uri = string.sub(vim.uri_to_fname(uri), #vim.fn.getcwd() + 2)
			notification = notification .. string.format("made %d change(s) in %s", #edits, short_uri)
		end

		-- print(string.format("updated %d instance(s) in %d file(s)", num_updates, num_files))
		require "notify"(notification, "info", {
			title = string.format("[lsp] rename: %s -> %s", position_params.oldName, position_params.newName),
			timeout = 2500,
		})

		-- FIXME: Requires implementation
		-- if num_files > 1 then
		-- 	require("utils").qf_populate(entries, "r")
		-- end
	end)
end
lsp.buf.rename = qf_rename
