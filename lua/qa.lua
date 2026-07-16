local setups = {}

function setups.precommit()
	-- https://github.com/Ttibsi/pre-commit.nvim
	-- Trigger pre-commit linters/formatter straight from within Neovim
	local precommit_defaults = nil
	setup_plugin("precommit", precommit_defaults)
end

function setups.conform()
	local conform_config = {
		formatters_by_ft = {
			python = {
				"ruff_fix",
				"ruff_format",
				"ruff_organize_imports",
				-- "mypy",
			},
			nix = {
				"alejandra",
			},
			lua = {
				"stylua",
			},
			haskell = {
				"fourmolu",
			},
			rust = {
				"rustfmt",
			},
			go = {
				"gofmt",
			},
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback", -- Use LSP formatting if available
		},
		formatters = {
			mypy = {
				command = "mypy",
				args = { "--no-error-summary", "--show-column-numbers", "--no-color-output", "$FILENAME" },
				stdin = false,
				-- Ignore exit code so it doesn't block save; use for diagnostics instead
				ignore_exitcode = true,
			},
		},
	}
	setup_plugin("conform", function(conform)
		conform.setup(conform_config)

		vim.api.nvim_create_autocmd("BufWritePre", {
			-- pattern = "*.py",
			callback = function(args)
				conform.format({ bufnr = args.buf })
			end,
			-- desc = "Format Python on save with conform",
		})
	end)
end

function setups.strict()
	-- https://github.com/emileferreira/nvim-strict
	-- Strict, native code style formatting plugin for Neovim. Expose deep nesting, overlong lines, trailing whitespace, trailing empty lines, todos and inconsistent indentation.
	local strict_defaults = {
		included_filetypes = nil,
		excluded_buftypes = { "help", "nofile", "terminal", "prompt" },
		match_priority = -1,
		deep_nesting = {
			highlight = true,
			highlight_group = "DiffDelete",
			depth_limit = 3,
			ignored_trailing_characters = nil,
			ignored_leading_characters = nil,
		},
		overlong_lines = {
			highlight = true,
			highlight_group = "DiffDelete",
			length_limit = 80,
			split_on_save = true,
		},
		trailing_whitespace = {
			highlight = true,
			highlight_group = "SpellBad",
			remove_on_save = true,
		},
		trailing_empty_lines = {
			highlight = true,
			highlight_group = "SpellBad",
			remove_on_save = true,
		},
		space_indentation = {
			highlight = false,
			highlight_group = "SpellBad",
			convert_on_save = false,
		},
		tab_indentation = {
			highlight = true,
			highlight_group = "SpellBad",
			convert_on_save = true,
		},
		todos = {
			highlight = true,
			highlight_group = "DiffAdd",
		},
	}
	local strict_config = {
		excluded_filetypes = { "lua" },
	}
	setup_plugin("strict", strict_config)
end

setup_all_enabled("qa", setups)
