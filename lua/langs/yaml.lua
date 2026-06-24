local function set_yaml_options()
	print("PLACEHOLDER")

	--TODO: move to where appropriate
end

local function general_setup()
	-- https://tangled.org/cuducos.me/yaml.nvim
	-- Simple tools to help developers working YAML in Neovim.
	local yaml_nvim_defaults = { ft = { "yaml", "<other yaml filetype>" } }
	setup_plugin("yaml_nvim", yaml_nvim_defaults)
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

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up YAML.")
	set_yaml_options(ev)
	general_setup()
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
