local function setup_miscellaneous()
	-- https://github.com/2nthony/sortjson.nvim
	-- A NeoVIM plugin that can sort current JSON file by key name.
	-- written in go
	local sortjson_defaults = {
		log_level = "WARN", -- log level, see `:h vim.log.levels`, print error info when parsing json failed
	}
	setup_plugin("sortjson", sortjson_defaults)
	--[[
local commands = {
	"SortJSONByAlphaNum",
	"SortJSONByAlphaNumReverse",
	"SortJSONByKeyLength",
	"SortJSONByKeyLengthReverse",
}
--]]

	-- https://github.com/phelipetls/jsonpath.nvim
	-- A Neovim plugin to help you access JSON values, powered by treesitter
	local jsonpath_defaults = {
		show_on_winbar = true,
	}
	setup_plugin("jsonpath", function(jsonpath)
		jsonpath.setup(jsonpath_defaults)

		-- maybe move to after/ftplugin/json.lua

		-- show json path in the winbar
		if vim.fn.exists("+winbar") == 1 then
			vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
		end

		-- send json path to clipboard
		map_explicit({
			mode = "n",
			sequence = "y<C-p>",
			action = function()
				vim.fn.setreg("+", require("jsonpath").get())
			end,
			desc = "copy json path",
			opts = { buffer = true },
		})
	end)

	-- https://github.com/b0o/SchemaStore.nvim
	-- JSON schemas for Neovim
	local jsonpath_defaults = nil
	setup_plugin("schemastore", function(schemastore)
		schemastore.json.schemas({
			extra = {
				{
					description = "Local JSON schema",
					fileMatch = "local.json",
					name = "local.json",
					url = "file:///path/to/your/schema.json", -- or '/path/to/your/schema.json'
				},
			},
		})
	end)
end

local function set_json_options()
	print("PLACEHOLDER")
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
	print("Setting up JSON.")
	set_json_options(ev)
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
