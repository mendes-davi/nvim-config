local ls = require "luasnip"
local s = ls.s
local sn = ls.sn
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local FMT = require "luasnip.extras.fmt"
local fmt = FMT.fmt
local fmta = FMT.fmta

local shared = R "snips"
local same = shared.same

return {
	s("fprint", fmta([[print(<>)<>]], { c(1, { i(1), sn(nil, { t "f'{", i(1, "var"), c(2, { t "}'", t " = }'" }) }) }), i(0) })),
}
