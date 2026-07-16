local setups = {}

setups["doc-window"] = function()
	-- https://github.com/resonyze/doc-window.nvim
	-- A plugin to display hover info you get from lsp in a separate buffer.
	setup_plugin("doc-window", {}) --TODO: DEPENDS ON ts_utils
end

function setups.refactoring()
	setup_plugin("refactoring", function(refactoring)
		refactoring.setup()
		local keymap = vim.keymap
		local debug = require("refactoring.debug")

		keymap.set({ "n", "x" }, "<leader>re", function()
			return require("refactoring").extract_func()
		end, { desc = "Extract Function", expr = true })
		-- `_` is the default textobject for "current line"
		keymap.set("n", "<leader>rel", function()
			return require("refactoring").extract_func() .. "_"
		end, { desc = "Extract Function (line)", expr = true })

		keymap.set({ "n", "x" }, "<leader>rE", function()
			return require("refactoring").extract_func_to_file()
		end, { desc = "Extract Function To File", expr = true })

		keymap.set({ "n", "x" }, "<leader>rv", function()
			return require("refactoring").extract_var()
		end, { desc = "Extract Variable", expr = true })

		-- `_` is the default textobject for "current line"
		keymap.set("n", "<leader>rvv", function()
			return require("refactoring").extract_var() .. "_"
		end, { desc = "Extract Variable (line)", expr = true })

		keymap.set({ "n", "x" }, "<leader>ri", function()
			return require("refactoring").inline_var()
		end, { desc = "Inline Variable", expr = true })
		keymap.set({ "n", "x" }, "<leader>rI", function()
			return require("refactoring").inline_func()
		end, { desc = "Inline function", expr = true })

		keymap.set({ "n", "x" }, "<leader>rs", function()
			return require("refactoring").select_refactor()
		end, { desc = "Select refactor" })

		-- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
		keymap.set("n", "<leader>pvb", function()
			return debug.print_var({ output_location = "below" }) .. "iw"
		end, { desc = "Debug print var below", expr = true })
		keymap.set("x", "<leader>pvb", function()
			return debug.print_var({ output_location = "below" })
		end, { desc = "Debug print var below", expr = true })

		-- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
		keymap.set("n", "<leader>pva", function()
			return debug.print_var({ output_location = "above" }) .. "iw"
		end, { desc = "Debug print var above", expr = true })
		keymap.set("x", "<leader>pva", function()
			return debug.print_var({ output_location = "above" })
		end, { desc = "Debug print var above", expr = true })

		keymap.set({ "x", "n" }, "<leader>peb", function()
			return debug.print_exp({ output_location = "below" })
		end, { desc = "Debug print exp below", expr = true })
		-- `_` is the default textobject for "current line"
		keymap.set("n", "<leader>pea", function()
			return debug.print_exp({ output_location = "below" }) .. "_"
		end, { desc = "Debug print exp below", expr = true })

		keymap.set({ "x", "n" }, "<leader>peb", function()
			return debug.print_exp({ output_location = "above" })
		end, { desc = "Debug print exp above", expr = true })
		-- `_` is the default textobject for "current line"
		keymap.set("n", "<leader>pea", function()
			return debug.print_exp({ output_location = "above" }) .. "_"
		end, { desc = "Debug print exp above", expr = true })

		keymap.set("n", "<leader>pla", function()
			return debug.print_loc({ output_location = "above" })
		end, { desc = "Debug print location above", expr = true })
		keymap.set("n", "<leader>plb", function()
			return debug.print_loc({ output_location = "below" })
		end, { desc = "Debug print location below", expr = true })

		keymap.set({ "x", "n" }, "<leader>pc", function()
			-- `ag` is a custom textobject that selects the whole buffer. It's provided by plugins like `mini.ai` (requires manual configuration using `MiniExtra.gen_ai_spec.buffer()`).
			-- return debug.cleanup { restore_view = true } .. "ag"

			-- this keymap doesn't select any textobject by default, so you need to provide one each time you use it.
			return debug.cleanup({ restore_view = true })
		end, { desc = "Debug print clean", expr = true, remap = true })
	end)
end

function setups.lint()
	-- https://github.com/mfussenegger/nvim-lint
	-- An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.
	setup_plugin("lint", function(lint)
		lint.linters_by_ft = {
			markdown = { "vale" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				lint.try_lint()

				-- You can call `try_lint` with a linter name or a list of names to always
				-- run specific linters, independent of the `linters_by_ft` configuration
				lint.try_lint("cspell")
			end,
		})
	end)
end

function setups.hlargs()
	-- https://github.com/m-demare/hlargs.nvim
	-- Highlight arguments' definitions and usages, using Treesitter
	local hlargs_defaults = {
		color = "#ef9062",
		highlight = {},
		excluded_filetypes = {},
		disable = function(lang, bufnr) -- If changed, `excluded_filetypes` will be ignored
			return vim.tbl_contains(opts.excluded_filetypes, lang)
		end,
		paint_arg_declarations = true,
		paint_arg_usages = true,
		paint_catch_blocks = {
			declarations = false,
			usages = false,
		},
		extras = {
			named_parameters = false,
			unused_args = false,
		},
		hl_priority = 120,
		excluded_argnames = {
			declarations = {},
			usages = {
				python = { "self", "cls" },
				lua = { "self" },
			},
		},
		performance = {
			parse_delay = 1,
			slow_parse_delay = 50,
			max_iterations = 400,
			max_concurrent_partial_parses = 30,
			debounce = {
				partial_parse = 3,
				partial_insert_mode = 100,
				total_parse = 700,
				slow_parse = 5000,
			},
		},
	}
	setup_plugin("hlargs", hlargs_defaults)
end

setup_all_enabled("lsp_like", setups)
