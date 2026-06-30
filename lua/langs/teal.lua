-- TODO: https://github.com/teal-language/teal-language-server

local function set_tl_options()
	print("PLACEHOLDER")
end

function setups.lsp()
	print("PLACEHOLDER")
end

function setups.testing()
	print("PLACEHOLDER")
end

function setups.debugging()
	print("PLACEHOLDER")
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up tl.")
	set_tl_options(ev)
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
