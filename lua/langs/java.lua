local function set_java_options()
	print("PLACEHOLDER")
end

function setups.lsp()
	-- https://github.com/Israiloff/jvim/
	-- Java Neovim IDE
	setup_plugin("jvim", {}) -- DEPENDS ON nvim-treesitter
end

function setups.testing()
	print("PLACEHOLDER")
end

function setups.debugging()
	print("PLACEHOLDER")
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up Java.")
	set_java_options(ev)
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
end

return M
