-- https://github.com/Israiloff/jvim/
-- Java Neovim IDE
setup_plugin("jvim", {}) -- DEPENDS ON nvim-treesitter

local M = {}

function M.setup(ev, features_enabled) end
print("Setting up Java.")
set_java_options(ev)
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
