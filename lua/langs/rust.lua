local function set_rust_options()
	print("PLACEHOLDER")
end

function setups.check_executable_dependencies() end

function setups.miscellaneous()
	setup_plugin("crates", function(crates)
		crates.setup({
			float_window = true,
			window_width = 0.8,
			window_height = 0.8,
			border = "rounded",
			auto_close = true,
			close_timeout = 5000,
		})

		local opts = { silent = true }

		map_explicit({
			mode = "n",
			sequence = "<leader>crt",
			action = crates.toggle,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crr",
			action = crates.reload,
			opts = opts,
		})

		map_explicit({
			mode = "n",
			sequence = "<leader>crv",
			action = crates.show_versions_popup,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crf",
			action = crates.show_features_popup,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crd",
			action = crates.show_dependencies_popup,
			opts = opts,
		})

		map_explicit({
			mode = "n",
			sequence = "<leader>cru",
			action = crates.update_crate,
			opts = opts,
		})
		map_explicit({
			mode = "v",
			sequence = "<leader>cru",
			action = crates.update_crates,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>cra",
			action = crates.update_all_crates,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crU",
			action = crates.upgrade_crate,
			opts = opts,
		})
		map_explicit({
			mode = "v",
			sequence = "<leader>crU",
			action = crates.upgrade_crates,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crA",
			action = crates.upgrade_all_crates,
			opts = opts,
		})

		map_explicit({
			mode = "n",
			sequence = "<leader>crx",
			action = crates.expand_plain_crate_to_inline_table,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crX",
			action = crates.extract_crate_into_table,
			opts = opts,
		})

		map_explicit({
			mode = "n",
			sequence = "<leader>crH",
			action = crates.open_homepage,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crR",
			action = crates.open_repository,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crD",
			action = crates.open_documentation,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crC",
			action = crates.open_crates_io,
			opts = opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>crL",
			action = crates.open_lib_rs,
			opts = opts,
		})
	end)

	setup_plugin("crates", {
		lsp = {
			enabled = true,
			on_attach = function(client, bufnr)
				-- the same on_attach function as for your other language servers
				-- can be ommited if you're using the `LspAttach` autocmd
			end,
			actions = true,
			completion = true,
			hover = true,
		},
		completion = {
			cmp = {
				use_custom_kind = true,
				-- optionally change the text and highlight groups
				kind_text = {
					version = "Version",
					feature = "Feature",
				},
				kind_highlight = {
					version = "CmpItemKindVersion",
					feature = "CmpItemKindFeature",
				},
			},
		},
		-- TODO: https://github.com/Saecki/crates.nvim/wiki/Documentation-unstable#nvim-cmp-source
	})
end

function setups.lsp()
	vim.g.rustaceanvim = {
		-- Plugin configuration
		tools = {},
		-- LSP configuration
		server = {
			on_attach = function(client, bufnr)
				-- you can also put keymaps in here
			end,
			default_settings = {
				-- rust-analyzer language server configuration
				["rust-analyzer"] = {},
			},
		},
		-- DAP configuration
		dap = {},
	}
	local rnv = setup_plugin("rustaceanvim")

	local bufnr = vim.api.nvim_get_current_buf()
	map_explicit({
		mode = "n",
		sequence = "<leader>rua",
		action = function()
			vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
			-- or vim.lsp.buf.codeAction() if you don't want grouping.
		end,
		opts = { desc = "Rust code action", silent = true, buffer = bufnr },
	})
	map_explicit({
		mode = "n",
		sequence = "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
		action = function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end,
		opts = { silent = true, buffer = bufnr },
	})

	-- TODO: probably extraneous with rustaceanvim
	vim.lsp.config["rust-analyzer"] =
		{ ------------------------------------------------------------------------------- RUST
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_markers = { { "Cargo.toml", "cargo.lock" }, ".git" },
			settings = {},
		}
end

function setups.testing()
	print("PLACEHOLDER")
end

function setups.debugging()
	print("PLACEHOLDER")
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up Rust.")
	setups.check_executable_dependencies()
	setups.rust_options(ev)
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
