local ls = require "luasnip"
local s = ls.s
local r = ls.restore_node
local sn = ls.sn
local isn = ls.indent_snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local FMT = require "luasnip.extras.fmt"
local fmta = FMT.fmta
local m = require("luasnip.extras").m

local shared = R "snips"
local same = shared.same

local autosnips = {
	s({ trig = "^clal", regTrig = true, hidden = true }, fmta([[clear all; close all; clc;]], {})),
}

ls.add_snippets("matlab", autosnips, {
	type = "autosnippets",
	key = "matlab_auto_snips",
})

return {
	s("docked", fmta([[set(0, 'DefaultFigureWindowStyle', 'docked');]], {})),
	s("hold", fmta([[hold(gca, '<>')<>]], { c(1, { t "on", t "off" }), i(0) })),
	s("font", fmta([[set(gca, 'FontName', 'Arial', 'FontSize', <>, 'FontWeight', 'normal');<>]], { i(1, "20"), i(0) })),
	s(
		"grid",
		fmta(
			[[
            set(gca, 'XGrid', 'on', 'YGrid', 'on');
            set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
            set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');]],
			{}
		)
	),
	s("label", fmta([[set(get(gca, '<>'), 'String', '<>');<>]], { c(1, { t "XLabel", t "YLabel" }), i(2), i(0) })),
	s("plot", fmta([[plot(<>, <>, <>);<>]], { i(1), i(2), c(3, { i(1), sn(nil, { t "'LineWidth', '", i(1, "2"), t "'", i(0) }) }), i(0) })),
}
