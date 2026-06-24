local M = {}

local function set_xit_options()
	print("PLACEHOLDER")
end

local function setup_miscellaneous()
	vim.opt.runtimepath:prepend("/home/isaac/repos/xit.nvim")
	require("xit").setup()
	print("Required xit.")
end

local function setup_lsp()
	print("PLACEHOLDER")
end

local function setup_testing()
	print("PLACEHOLDER")
end

local function setup_debugging()
	print("PLACEHOLDER")
end

function M.setup(ev, features_enabled)
	print("Setting up [x]it!.")
	set_xit_options(ev)
	setup_miscellaneous()
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
