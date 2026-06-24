-- TELESCOPE =================================================================================================

local telescope = utils.setup_plugin_default("telescope", function(telescope)
	telescope.setup({
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
		defaults = {
			mappings = {
				i = {
					-- Movement
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["<C-d>"] = "preview_scrolling_down",
					["<C-u>"] = "preview_scrolling_up",
					-- Actions
					["<C-q>"] = "send_to_qflist",
					["<C-l>"] = "complete_tag",
					["<C-x>"] = "select_horizontal",
					["<C-v>"] = "select_vertical",
					["<C-t>"] = "select_tab",
					["<Esc>"] = false,
					["<C-c>"] = "close",
				},
				n = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["j"] = "move_selection_next",
					["k"] = "move_selection_previous",
					["gg"] = "move_to_top",
					["G"] = "move_to_bottom",
					["<C-d>"] = "preview_scrolling_down",
					["<C-u>"] = "preview_scrolling_up",
					["q"] = "close",
					["<Esc>"] = "close", -- close from normal mode
				},
			},
			preview = {
				treesitter = true,
				filetype_hook = function(filepath, bufnr, opts)
					local ft = vim.filetype.match({ filename = filepath, buf = bufnr })
					if ft then
						vim.bo[bufnr].filetype = ft
					end
					return true
				end,
			},
		},
	})
	telescope.load_extension("advanced_git_search")
	telescope.load_extension("fzf")
	telescope.load_extension("project")
	-- print("loaded telescope with fzf-native")

	local telescope_builtin = require("telescope.builtin")
	map_explicit({
		mode = "n",
		sequence = "<leader>ff",
		action = function()
			telescope_builtin.find_files()
		end,
		desc = "Telescope: Find Files",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>gf",
		action = function()
			telescope_builtin.git_files()
		end,
		desc = "Telescope: Find Git Files",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>fg",
		action = function()
			require("telescope.builtin").live_grep()
		end,
		desc = "Telescope: Live Grep",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>fb",
		action = function()
			telescope_builtin.buffers()
		end,
		desc = "Telescope: Find Buffers",
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>fh",
		action = function()
			telescope_builtin.help_tags()
		end,
		desc = "Telescope: Find Help Tags",
	})
end)
