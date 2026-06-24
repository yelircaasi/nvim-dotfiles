-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "haskell",
-- 	callback = function()
-- 		print("Haskell file detected!")
-- 		local ht = setup_plugin("haskell-tools")
-- 		ht.lsp.start()
-- 	end,
-- })

local function set_haskell_options()
	print("PLACEHOLDER")
end

local function setup_lsp()
	local ht = setup_plugin("haskell-tools")
	local bufnr = vim.api.nvim_get_current_buf()
	local opts = { noremap = true, silent = true, buffer = bufnr }
	-- haskell-language-server relies heavily on codeLenses,
	-- so auto-refresh (see advanced configuration) is enabled by default
	map_explicit({
		mode = "n",
		sequence = "<space>cl",
		action = vim.lsp.codelens.run,
		opts = opts,
		desc = "Run codelens",
	})
	map_explicit({
		mode = "n",
		sequence = "<space>hs",
		action = ht.hoogle.hoogle_signature,
		opts = opts,
		desc = "Hoogle search type signature",
	})
	map_explicit({
		mode = "n",
		sequence = "<space>ea",
		action = ht.lsp.buf_eval_all,
		opts = opts,
		desc = "Evaluate all code snippets",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>rr",
		action = ht.repl.toggle,
		opts = opts,
		desc = "Toggle a GHCi repl for the current package",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>rf",
		action = function()
			ht.repl.toggle(vim.api.nvim_buf_get_name(0))
		end,
		opts = opts,
		desc = "Toggle a GHCi repl for the current buffer",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>rq",
		action = ht.repl.quit,
		opts = opts,
		desc = "Quit REPL",
	})

	-- TODO: below may be superfluous given haskell-tools
	vim.lsp.config["haskell-language-server"] = {
		cmd = { "haskell-language-server" },
		filetypes = { "haskell" },
		root_markers = { { "*.cabal" }, ".git" },
		settings = {},
	}

	vim.lsp.config["haskell-ls"] = {} -- TODO (?)
end

local function setup_testing()
	print("PLACEHOLDER")
end

local function setup_debugging()
	print("PLACEHOLDER")
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up Haskell.")
	set_haskell_options(ev)
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
