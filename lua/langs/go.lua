local function set_go_options()
	print("PLACEHOLDER")
end

local function setup_lsp()
	setup_plugin("go") -- TODO: guihua
	setup_plugin("gopher")
end

local function setup_testing()
	print("PLACEHOLDER")
end

local function setup_debugging()
	print("PLACEHOLDER")
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up Go.")
	set_go_options(ev)
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
