COQsources = COQsources or {}

local utils = require "coq_3p.utils"

require "coq_3p" {
	-- { src = "vimtex", short_name = "vTEX" },
	{ src = "nvimlua", short_name = "nLUA", conf_only = true },
	{ src = "dap" },
}
