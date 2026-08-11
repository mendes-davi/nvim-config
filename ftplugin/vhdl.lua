vim.opt_local.comments = "f:-- "
vim.opt_local.commentstring = "-- %s"

vim.opt_local.suffixesadd:append { ".vhd" }
vim.opt_local.includeexpr = "substitute(v:fname,'work\\.','','g')"

vim.opt_local.path:append { "dev/targets/*/VHD" }
vim.opt_local.path:append { "dev/targets/*/Testbench" }
vim.opt_local.path:append { "dev/modules/**/VHD" }
