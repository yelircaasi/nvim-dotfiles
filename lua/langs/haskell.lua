local ht = setup_plugin("haskell-tools")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "haskell",
	callback = function()
		print("Haskell file detected!")
		local ht = setup_plugin("haskell-tools")
		ht.lsp.start()
	end,
})

vim.lsp.config["haskell-language-server"] = { ------------------------------------------------------------------ HASKELL
	cmd = { "haskell-language-server" },
	filetypes = { "haskell" },
	root_markers = { { "*.cabal" }, ".git" },
	settings = {},
}

vim.lsp.config["haskell-ls"] = {} -- TODO (?)

local M = {}

function M.setup(ev, features_enabled) end
print("Setting up Haskell.")
set_haskell_options(ev)
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
