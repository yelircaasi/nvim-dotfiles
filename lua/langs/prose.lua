function setups.vale()
	-- https://github.com/marcelofern/vale.nvim
	-- A Neovim wrapper around Vale, the syntax-aware linter for prose.
	local vale_defaults = {
		-- path to the vale binary.
		bin = "/bin/vale",
		-- path to your vale-specific configuration.
		vale_config_path = "$HOME/.config/vale/vale.ini",
	}
	setup_plugin("vale", vale_defaults)
end
