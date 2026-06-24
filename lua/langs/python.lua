-- vim.api.nvim_set_keymap('n', 'ee', '<cmd>lua require("equals").buffer()<cr>', {noremap = true})

-- TODO: set up pylsp-rope for refactoring

-- Mypy integration
-- Option 1: Via nvim-lint (recommended for live diagnostics)
-- Option 2: Use conform for on-save mypy checks (slower but thorough)

-- pip install "python-lsp-server[all]" pylsp-mypy

-- TODO: set up basedpyright

local function set_python_options(ev)
	vim.bo[ev.buf].shiftwidth = 4
	vim.keymap.set("n", "<localleader>r", "<cmd>!python %<cr>", { buffer = ev.buf })
end

local function setup_lsp()
	setup_plugin("mypy", {
		-- additional arguments to pass to invocations of `mypy`
		-- by default, it is called with `--show-error-end --follow-imports=silent`
		extra_args = { "--check-untyped-defs", "--verbose" },
		-- override mypy diagnostic severities
		-- the default is { error = vim.diagnostic.severity.WARN, note = vim.diagnostic.severity.HINT }
		severities = { error = vim.diagnostic.severity.ERROR, note = vim.diagnostic.severity.INFO },
	})
	vim.lsp.config["ruff"] =
		{ -------------------------------------------------------------------------------------- PYTHON
			cmd = { "ruff", "server" },
			filetypes = { "python" },
			root_markers = { { ".ruff_cache", "pyproject.toml" }, ".git" },
			-- {
			-- 	 "pyproject.toml",
			--   "ruff.toml",
			-- 	 ".ruff.toml",
			-- 	 "setup.py",
			-- 	 "setup.cfg",
			-- 	 "requirements.txt",
			--   ".git",
			-- }
			-- example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
			settings = {},
		}
	vim.lsp.config["basedpyright"] = {
		cmd = { "basedpyright-langserver", "--stdio" },
		filetypes = { "python" },
		root_markers = {
			{ "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
			".git",
		},
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					typeCheckingMode = "basic", -- alternative: "strict"
				},
			},
		},
	}

	vim.lsp.enable("pylsp")
	vim.lsp.enable("basedpyright")
	vim.lsp.enable("ruff")
end

local function setup_testing()
	local function get_neotest_python_adapter()
		utils.packadd("neotest")
		utils.packadd("neotest-python")
		local python_adapter = require("neotest-python")({
			dap = { justMyCode = false },
			python = function(_)
				return utils.get_executable("python")
			end,
			runner = "pytest",
		})
	end
	require("testing").setup_testing_for_lang({
		language = "python",
		neotest_adapter = get_neotest_python_adapter(),
		-- coverage_langspec = ...,
		-- neotest_overrides = ...,
		-- coverage_overrides = ...,
	})
end

local function setup_equals()
	-- https://github.com/liborw/equals
	-- takes python code or markdown with python code blocks and append intermediate results to expressions followed by #=
	local equals_defaults = {
		set_keys = true,
	}
	setup_plugin("equals", equals_defaults)
end

local function setup_debugging()
	setup_plugin("debugpy", function(_) end)

	setup_plugin("dap-python", function(dap_python)
		-- local dap_python = utils.get_plugin("dap-python")
		dap_python.setup("debugpy-adapter")
		dap_python.test_runner = "pytest"
		map_explicit({
			mode = "n",
			sequence = "<leader>te",
			action = utils.mkprint("Leader is working!"),
		})
		-- map_explicit({
		-- 	mode = "n",
		-- 	sequence = "<leader>pp",
		-- 	action = utils.mkprint("This works"),
		-- })
		map_explicit({
			mode = "n",
			sequence = "<leader>dn",
			action = dap_python.test_method,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>dpc",
			action = dap_python.test_class,
		})
		map_explicit({
			mode = "v",
			sequence = "<leader>ds",
			action = dap_python.debug_selection,
		})
	end)
	-- TODO: proposed:
	--[[
	setup_plugin("dap-python", function(dap_python)
		dap_python.setup("debugpy-adapter")
		dap_python.test_runner = "pytest"
	end)
	]]
end

local M = {}

function M.setup(ev, features_enabled)
	print("Setting up Python.")
	set_python_options(ev)
	setup_equals()
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
end

return M
