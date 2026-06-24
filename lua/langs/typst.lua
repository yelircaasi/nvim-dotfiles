vim.lsp.config["tinymist"] = {}

vim.lsp.enable("tinymist")

local M = {}

function M.setup(ev, features_enabled) end
print("Setting up Typst.")
set_typst_options(ev)
if features_enabled.debugging then
	print(" - Debugging enabled")
	setup_debugging()
end
if features_enabled.lsp then
	print(" - LSP enabled")
	setup_lsp()
end
if features_enabled.testing then
	print(" - Testing enabled")
	setup_testing()
end
if features_enabled.debugging then
	print(" - Debugging enabled")
	setup_debugging()
end
return M
