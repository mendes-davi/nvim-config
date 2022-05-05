COQsources = COQsources or {}

local utils = require "coq_3p.utils"

require "coq_3p" {
	{ src = "vimtex", short_name = "vTEX" },
	{ src = "nvimlua", short_name = "nLUA", conf_only = true },
	{ src = "dap" },
}

COQsources[utils.new_uid(COQsources)] = {
	name = "UltiSnips",
	fn = function(args, callback)
		-- label      :: display label
		-- insertText :: string | null, default to `label` if null
		-- kind       :: int ∈ `vim.lsp.protocol.CompletionItemKind`
		-- detail     :: doc popup

		local items = {}
		for key, val in pairs(vim.fn["UltiSnips#SnippetsInCurrentScope"]()) do
			local item = {
				label = tostring(key),
				insertText = key,
				detail = tostring(val),
				kind = vim.lsp.protocol.CompletionItemKind.Snippet,
			}
			table.insert(items, item)
		end
		callback { isIncomplete = true, items = items }
	end,
}
