local setups = {}
print("requiring nix.lua")

function setups.miscellaneous()
	-- https://github.com/figsoda/nix-develop.nvim
	-- Run `nix develop` without restarting neovim
	local nix_develop_defaults = nil
	setup_plugin("nix-develop", function(nd)
		-- examples
		nd.ignored_variables["SHELL"] = false
		nd.separated_variables["LUA_PATH"] = ":"

		-- === functions available for binding: =========
		-- nd.enter_dev_env
		-- nd.devenv_shell
		-- nd.nix_develop
		-- nd.nix_shell
		-- ==============================================

		-- vim:tw=78:ts=8:noet:ft=help:norl:
	end)
	--[[
	:NixDevelop
	:NixDevelop .#foo
	:NixDevelop --impure

	:NixShell
	:NixShell nixpkgs#hello

	:DevenvShell
	:DevenvShell --profile foo
	--]]
end

function setups.options()
	print("PLACEHOLDER")
end

function setups.lsp()
	vim.lsp.config = {
		["nixd"] = {
			cmd = { "nixd" },
			filetypes = { "nix" },
			root_markers = { "flake.nix", ".git" },
			settings = {},
		},
		["nil"] = {
			cmd = { "nil" },
			filetypes = { "nix" },
			root_markers = { "flake.nix", ".git" },
			settings = {},
		},
	}

	vim.lsp.enable("nixd")
	vim.lsp.enable("nil")
end

function setups.testing()
	print("PLACEHOLDER")
end

function setups.debugging()
	print("PLACEHOLDER")
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up Nix.")
	setups.options()
	setups.miscellaneous()
	if features_enabled.lsp then
		print(" - LSP enabled")
		setups.lsp()
	end
	if features_enabled.testing then
		print(" - Testing enabled")
		setups.testing()
	end
	if features_enabled.debugging then
		print(" - Debugging enabled")
		setups.debugging()
	end
end

return M
