local builtin = require "statuscol.builtin"

require("statuscol").setup {
	segments = {
		{ text = { "%s" }, click = "v:lua.ScSa" },
		{
			text = {
				function(args)
					for _, mark in ipairs(vim.fn.getmarklist(args.buf)) do
						if mark.pos[2] == args.lnum then
							return mark.mark:sub(-1)
						end
					end
					return ""
				end,
			},
		},
		{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
		{
			text = { " ", builtin.foldfunc, " " },
			condition = { builtin.not_empty, true, builtin.not_empty },
			click = "v:lua.ScFa",
		},
	},
}
