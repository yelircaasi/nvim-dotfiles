local setups = {}

-- setup_plugin("plenary")
-- setup_plugin("nio")

--─────────────────────────────────────────────────────────────────────────────
--──── fonts, characters ──────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.icons()
	if vim.g.nerdfont then
		utils.printv("Using nerd icons")
		setup_plugin("nvim-web-devicons", {
			-- your personal icons can go here (to override)
			-- you can specify color or cterm_color instead of specifying both of them
			-- DevIcon will be appended to `name`
			override = {
				zsh = {
					icon = "",
					color = "#428850",
					cterm_color = "65",
					name = "Zsh",
				},
			},
			-- globally enable different highlight colors per icon (default to true)
			-- if set to false all icons will have the default icon's color
			color_icons = true,
			-- globally enable default icons (default to false)
			-- will get overriden by `get_icons` option
			default = true,
			-- globally enable "strict" selection of icons - icon will be looked up in
			-- different tables, first by filename, and if not found by extension; this
			-- prevents cases when file doesn't have any extension but still gets some icon
			-- because its name happened to match some extension (default to false)
			strict = true,
			-- set the light or dark variant manually, instead of relying on `background`
			-- (default to nil)
			variant = "light|dark",
			-- override blend value for all highlight groups :h highlight-blend.
			-- setting this value to `0` will make all icons opaque. in practice this means
			-- that icons width will not be affected by pumblend option (see issue #608)
			-- (default to nil)
			blend = 0,
			-- same as `override` but specifically for overrides by filename
			-- takes effect when `strict` is true
			override_by_filename = {
				[".gitignore"] = {
					icon = "",
					color = "#f1502f",
					name = "Gitignore",
				},
			},
			-- same as `override` but specifically for overrides by extension
			-- takes effect when `strict` is true
			override_by_extension = {
				["log"] = {
					icon = "",
					color = "#81e043",
					name = "Log",
				},
			},
			-- same as `override` but specifically for operating system
			-- takes effect when `strict` is true
			override_by_operating_system = {
				["apple"] = {
					icon = "",
					color = "#A2AAAD",
					cterm_color = "248",
					name = "Apple",
				},
			},
		})
	else
		-- TODO: integrate with nvim-tree, bufferline, lualine
		-- https://github.com/dullmode/bye-nerdfont.nvim
		-- devicons without nerdfont
		local bye_nerdfont_defaults = {
			mode = "emoji", -- alternative: "simple"
		}
		setup_plugin("bye-nerdfont", bye_nerdfont_defaults)
	end
end
--─────────────────────────────────────────────────────────────────────────────
--──── columns ────────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.virtcolumn()
	-- EXPERIMENTAL
	-- TODO: compare https://github.com/lukas-reineke/virt-column.nvim (may be better)
	-- https://github.com/xiyaowong/virtcolumn.nvim
	-- Display a line as the colorcolumn
	local virtcolumn_defaults = nil
	utils.packadd("virtcolumn", function(virtcolumn)
		vim.g.virtcolumn_char = "▕" -- char to display the line
		vim.g.virtcolumn_priority = 10 -- priority of extmark
	end)
end

setups["virt-column"] = function()
	-- :help virt-column.txt
	-- https://github.com/lukas-reineke/virt-column.nvim
	-- Display a character as the colorcolumn
	local virt_column_defaults = {} -- TODO: https://github.com/lukas-reineke/virt-column.nvim/blob/master/lua/virt-column/config.lua
	setup_plugin("virt-column", function(virt_column)
		virt_column.setup(virt_column_defaults)
	end)
end

function setups.smartcolumn()
	-- https://github.com/m4xshen/smartcolumn.nvim
	-- A Neovim plugin hiding your colorcolumn when unneeded.
	local smartcolumn_defaults = {
		colorcolumn = "80",
		disabled_filetypes = { "help", "text", "markdown" },
		custom_colorcolumn = {},
		scope = "file",
		editorconfig = true,
	}
	setup_plugin("smartcolumn", smartcolumn_defaults)
end

function setups.statuscol()
	-- https://github.com/luukvbaal/statuscol.nvim
	-- Status column plugin that provides a configurable 'statuscolumn' and click handlers.
	setup_plugin("statuscol", function(statuscol)
		local builtin = require("statuscol.builtin")
		local statuscol_defaults = {
			setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
			-- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
			-- Although I recommend just using the segments field below to build your
			-- statuscolumn to benefit from the performance optimizations in this plugin.
			-- builtin.lnumfunc number string options
			thousands = false, -- or line number thousands separator string ("." / ",")
			relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
			-- Builtin 'statuscolumn' options
			ft_ignore = nil, -- Lua table with 'filetype' values for which 'statuscolumn' will be unset
			bt_ignore = nil, -- Lua table with 'buftype' values for which 'statuscolumn' will be unset
			-- Default segments (fold -> sign -> line number + separator), explained below
			segments = {
				{ text = { "%C" }, click = "v:lua.ScFa" },
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{
					text = { builtin.lnumfunc, " " },
					condition = { true, builtin.not_empty },
					click = "v:lua.ScLa",
				},
			},
			clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
			-- "a" for Alt, "c" for Ctrl and "m" for Meta.
			clickhandlers = { -- builtin click handlers, keys are pattern matched
				Lnum = builtin.lnum_click,
				FoldClose = builtin.foldclose_click,
				FoldOpen = builtin.foldopen_click,
				FoldOther = builtin.foldother_click,
				DapBreakpointRejected = builtin.toggle_breakpoint,
				DapBreakpoint = builtin.toggle_breakpoint,
				DapBreakpointCondition = builtin.toggle_breakpoint,
				["diagnostic/signs"] = builtin.diagnostic_click,
				gitsigns = builtin.gitsigns_click,
			},
		}
		statuscol.setup(statuscol_defaults)
	end)
end

--─────────────────────────────────────────────────────────────────────────────
--──── outline ────────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.treepin()
	-- https://github.com/KaityyUwU/TreePin
	-- A lightweight neovim plugin for pinning fragments of code to the screen.
	setup_plugin("TreePin", {}) -- TODO: REQUIRES UPDATE FROM nvim-treesitter
end

function setups.symbols()
	-- https://github.com/oskarrrrrrr/symbols.nvim
	-- Code navigation sidebar for Neovim.
	local symbols_defaults = {
		sidebar = {
			-- Hide the cursor when in sidebar.
			hide_cursor = true,
			-- Side on which the sidebar will open, available options:
			-- try-left  Opens to the left of the current window if there are no
			--           windows there. Otherwise opens to the right.
			-- try-right Opens to the right of the current window if there are no
			--           windows there. Otherwise opens to the left.
			-- right     Always opens to the right of the current window.
			-- left      Always opens to the left of the current window.
			open_direction = "try-left",
			-- Whether to run `wincmd =` after opening a sidebar.
			on_open_make_windows_equal = true,
			-- Whether the cursor in the sidebar should automatically follow the
			-- cursor in the source window. Does not unfold the symbols. You can jump
			-- to symbol with unfolding with "gs" by default.
			cursor_follow = true,
			auto_resize = {
				-- When enabled the sidebar will be resized whenever the view changes.
				-- For example, after folding/unfolding symbols, after toggling inline details
				-- or whenever the source file is saved.
				enabled = true,
				-- The sidebar will never be auto resized to a smaller width then `min_width`.
				min_width = 20,
				-- The sidebar will never be auto resized to a larger width then `max_width`.
				max_width = 40,
			},
			-- Default sidebar width.
			fixed_width = 30,
			-- Allows to filter symbols. By default all the symbols are shown.
			symbol_filter = function(filetype, symbol)
				return true
			end,
			-- Show inline details by default.
			show_inline_details = false,
			-- Show details floating window at all times.
			show_details_pop_up = false,
			-- When enabled every symbol will be automatically peeked after cursor
			-- movement.
			auto_peek = false,
			-- Whether the sidebar should unfold the target buffer on goto
			-- This simply sends a zv after the zz
			unfold_on_goto = false,
			-- Whether to close the sidebar on goto symbol.
			close_on_goto = false,
			-- Whether the sidebar should wrap text.
			wrap = false,
			-- Whether to show the guide lines.
			show_guide_lines = true,
			chars = {
				folded = "",
				unfolded = "",
				guide_vert = "│",
				guide_middle_item = "├",
				guide_last_item = "└",
				-- use this highlight group for the guide lines
				hl_guides = "Comment",
				-- use this highlight group for the collapse/expand markers
				hl_foldmarker = "String",
			},
			-- highlight group for the inline details shown next to the symbol name
			-- (provider - dependent)
			hl_details = "Comment",
			-- Config for the preview window.
			preview = {
				-- Whether the preview window is always opened when the sidebar is
				-- focused.
				show_always = false,
				-- Whether the preview window should show line numbers.
				show_line_number = false,
				-- Whether to determine the preview window's height automatically.
				auto_size = true,
				-- The total number of extra lines shown in the preview window.
				auto_size_extra_lines = 6,
				-- Minimum window height when `auto_size` is true.
				min_window_height = 7,
				-- Maximum window height when `auto_size` is true.
				max_window_height = 30,
				-- Preview window size when `auto_size` is false.
				fixed_size_height = 12,
				-- Desired preview window width. Actuall width will be capped at
				-- the current width of the source window width.
				window_width = 100,
				-- Keymaps for actions in the preview window. Available actions:
				-- close: Closes the preview window.
				-- goto-code: Changes window to the source code and moves cursor to
				--            the same position as in the preview window.
				-- Note: goto-code is not set by default because the most natual
				-- key would be Enter but some people already have that key mapped.
				keymaps = {
					["q"] = "close",
				},
			},
			-- Keymaps for actions in the sidebar. All available actions are used
			-- in the default keymaps.
			keymaps = {
				-- Jumps to symbol in the source window.
				["<CR>"] = "goto-symbol",
				-- Jumps to symbol in the source window but the cursor stays in the
				-- sidebar.
				["<RightMouse>"] = "peek-symbol",
				["o"] = "peek-symbol",

				-- Opens a floating window with symbol preview.
				["K"] = "open-preview",
				-- Opens a floating window with symbol details.
				["d"] = "open-details-window",

				-- In the sidebar jumps to symbol under the cursor in the source
				-- window. Unfolds all the symbols on the way.
				["gs"] = "show-symbol-under-cursor",
				-- Jumps to parent symbol. Can be used with a count, e.g. "3gp"
				-- will go 3 levels up.
				["gp"] = "goto-parent",
				-- Jumps to the previous symbol at the same nesting level.
				["[["] = "prev-symbol-at-level",
				-- Jumps to the next symbol at the same nesting level.
				["]]"] = "next-symbol-at-level",

				-- Unfolds the symbol under the cursor.
				["l"] = "unfold",
				["zo"] = "unfold",
				-- Unfolds the symbol under the cursor and all its descendants.
				["L"] = "unfold-recursively",
				["zO"] = "unfold-recursively",
				-- Reduces folding by one level. Can be used with a count,
				-- e.g. "3zr" will unfold 3 levels.
				["zr"] = "unfold-one-level",
				-- Unfolds all symbols in the sidebar.
				["zR"] = "unfold-all",

				-- Folds the symbol under the cursor.
				["h"] = "fold",
				["zc"] = "fold",
				-- Folds the symbol under the cursor and all its descendants.
				["H"] = "fold-recursively",
				["zC"] = "fold-recursively",
				-- Increases folding by one level. Can be used with a count,
				-- e.g. "3zm" will fold 3 levels.
				["zm"] = "fold-one-level",
				-- Folds all symbols in the sidebar.
				["zM"] = "fold-all",

				-- Start fuzzy search.
				["s"] = "search",

				-- Toggles inline details (see sidebar.show_inline_details).
				["td"] = "toggle-inline-details",
				-- Toggles auto details floating window (see sidebar.show_details_pop_up).
				["tD"] = "toggle-auto-details-window",
				-- Toggles auto preview floating window.
				["tp"] = "toggle-auto-preview",
				-- Toggles cursor hiding (see sidebar.auto_resize.
				["tch"] = "toggle-cursor-hiding",
				-- Toggles cursor following (see sidebar.cursor_follow).
				["tcf"] = "toggle-cursor-follow",
				-- Toggles symbol filters allowing the user to see all the symbols
				-- given by the provider.
				["tf"] = "toggle-filters",
				-- Toggles automatic peeking on cursor movement (see sidebar.auto_peek).
				["to"] = "toggle-auto-peek",
				-- Toggles closing on goto symbol (see sidebar.close_on_goto).
				["tg"] = "toggle-close-on-goto",
				-- Toggles automatic sidebar resizing (see sidebar.auto_resize).
				["t="] = "toggle-auto-resize",
				-- Decrease auto resize max width by 5. Works with a count.
				["t["] = "decrease-max-width",
				-- Increase auto resize max width by 5. Works with a count.
				["t]"] = "increase-max-width",

				-- Toggle fold of the symbol under the cursor.
				["<2-LeftMouse>"] = "toggle-fold",

				-- Close the sidebar window.
				["q"] = "close",

				-- Show help.
				["?"] = "help",
				["g?"] = "help",
			},
		},
		providers = {
			-- Order in which providers will be called to get symbols.
			priority = {
				-- Default in case other rules are not defined.
				["*"] = { "treesitter", "lsp" },
				-- Treesitter provider for JSON can be slow for large files.
				json = { "lsp", "treesitter" },
				python = { "treesitter", "lsp" },
			},
			-- Override the priority using extra context.
			-- Input has the following fields:
			--  * filetype string
			--  * path string - absolute path
			--
			-- Return `nil` to fall back to `priority` table.
			priority_fun = function(input)
				return nil
			end,
			lsp = {
				timeout_ms = 1000,
				details = {},
				kinds = { default = {} },
				highlights = {
					-- ...
					default = {},
				},
			},
			treesitter = {
				details = {},
				kinds = { default = {} },
				highlights = {
					-- ...
					default = {},
				},
			},
		},
		dev = {
			enabled = false,
			log_level = vim.log.levels.ERROR,
			keymaps = {},
		},
	}
	setup_plugin("symbols", symbols_defaults)
end

function setups.aerial()
	-- TODO: maybe use aerial instead of navbuddy
	-- https://github.com/stevearc/aerial.nvim
	-- Neovim plugin for a code outline window
	local aerial_config = {
		layout = {
			min_width = 30,
			default_direction = "prefer_right",
		},
		attach_mode = "window",
		close_automatic_events = {
			"unsupported",
			"switch_buffer",
		},
	}
	setup_plugin("aerial", function(aerial)
		aerial.setup(aerial_config)

		map_explicit({
			mode = "n",
			sequence = "<leader>ou",
			action = "<cmd>AerialToggle<cr>",
		})
		map_explicit({
			mode = "n",
			sequence = "{",
			action = "<cmd>AerialPrev<cr>",
		})
		map_explicit({
			mode = "n",
			sequence = "}",
			action = "<cmd>AerialNext<cr>",
		})
	end)
end

function setups.navbuddy()
	-- utils.packadd("nui") -- TODO: comment out after next build
	-- https://github.com/SmiteshP/nvim-navbuddy
	-- A simple popup display that provides breadcrumbs feature using LSP server
	setup_plugin("nvim-navbuddy", function(navbuddy)
		navbuddy.setup({
			lsp = {
				auto_attach = true,
			},
		})

		map_explicit({
			mode = "n",
			sequence = "<leader>nb",
			action = function()
				navbuddy.open()
			end,
		})
	end)
end

function setups.dropbar()
	-- https://github.com/Bekaboo/dropbar.nvim
	-- IDE-like breadcrumbs, out of the box
	local dropbar_config = {
		-- bar = {
		-- 	padding = {
		-- 		left = 1,
		-- 		right = 1,
		-- 	},
		-- },
	}
	setup_plugin("dropbar", function(dropbar)
		dropbar.setup(dropbar_config)

		vim.ui.select = require("dropbar.utils.menu").select

		map_explicit({
			mode = "n",
			sequence = "<leader>;",
			action = function()
				require("dropbar.api").pick()
			end,
		})

		map_explicit({
			mode = "n",
			sequence = "[;",
			action = function()
				require("dropbar.api").goto_context_start()
			end,
		})

		map_explicit({
			mode = "n",
			sequence = "];",
			action = function()
				require("dropbar.api").select_next_context()
			end,
		})
	end)
end

--─────────────────────────────────────────────────────────────────────────────
--──── lines, bars ────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.lualine()
	-- https://github.com/nvim-lualine/lualine.nvim
	-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
	--[[
    setup_plugin("lualine", ) --, lualine_config)
    ]]

	local function lualine_bubbles(lualine)
		-- don't split bar; use single bar
		vim.o.laststatus = 3

		-- local colors = {
		-- 	blue = "#80a0ff",
		-- 	cyan = "#79dac8",
		-- 	black = "#080808",
		-- 	white = "#c6c6c6",
		-- 	red = "#ff5189",
		-- 	violet = "#d183e8",
		-- 	grey = "#303030",
		-- }

		-- local bubbles_theme = {
		-- 	normal = {
		-- 		a = { fg = colors.black, bg = colors.violet },
		-- 		b = { fg = colors.white, bg = colors.grey },
		-- 		c = { fg = colors.white },
		-- 	},

		-- 	insert = { a = { fg = colors.black, bg = colors.blue } },
		-- 	visual = { a = { fg = colors.black, bg = colors.cyan } },
		-- 	replace = { a = { fg = colors.black, bg = colors.red } },

		-- 	inactive = {
		-- 		a = { fg = colors.white, bg = colors.black },
		-- 		b = { fg = colors.white, bg = colors.black },
		-- 		c = { fg = colors.white },
		-- 	},
		-- }

		-- local half_circles = { right = "", left = "" }

		-- local OLD_cfg = {
		-- 	options = {
		-- 		theme = bubbles_theme,
		-- 		component_separators = "  ",
		-- 		section_separators = half_circles,
		-- 	},
		-- 	sections = {
		-- 		lualine_a = {
		-- 			{ "mode", separator = { left = half_circles.left }, right_padding = 2 },
		-- 		},
		-- 		lualine_b = { "filename", "branch" },
		-- 		lualine_c = {
		-- 			"%=", --[[ add your center components here in place of this comment ]]
		-- 		},
		-- 		lualine_x = {},
		-- 		lualine_y = {
		-- 			{ "filetype", "progress" },
		-- 		},
		-- 		lualine_z = {
		-- 			{ "location", separator = { right = half_circles.right }, left_padding = 2 },
		-- 		},
		-- 	},
		-- 	inactive_sections = {
		-- 		lualine_a = {}, -- "filename" },
		-- 		lualine_b = {},
		-- 		lualine_c = {},
		-- 		lualine_x = {},
		-- 		lualine_y = {},
		-- 		lualine_z = {}, -- "location" },
		-- 	},
		-- 	tabline = {},
		-- 	extensions = {},
		-- }

		local bubbles_theme = {
			normal = {
				a = { fg = "#181825", bg = "#cba6f7" },
				b = { fg = "#cdd6f4", bg = "#313244" },
				c = { fg = "#cdd6f4", bg = "#181825" },
			},
			insert = { a = { fg = "#181825", bg = "#a6e3a1" } },
			visual = { a = { fg = "#181825", bg = "#fab387" } },
			replace = { a = { fg = "#181825", bg = "#f38ba8" } },
			command = { a = { fg = "#181825", bg = "#f9e2af" } },
			inactive = {
				a = { fg = "#6c7086", bg = "#181825" },
				b = { fg = "#6c7086", bg = "#181825" },
				c = { fg = "#6c7086", bg = "#181825" },
			},
		}

		-- ── Reusable bubble wrapper ───────────────────────────────────────────────
		-- Wraps a component in rounded bubble separators with a custom highlight.
		local function bubble(component, hl_group, opts)
			opts = opts or {}
			return vim.tbl_extend("force", {
				component,
				separator = { right = "", left = "" }, -- { left = "", right = "" },
				padding = { left = 2, right = 2 },
				color = hl_group,
			}, opts)
		end

		-- ── Center bubbles ────────────────────────────────────────────────────────

		local git_bubble = bubble("branch", { fg = "#181825", bg = "#89b4fa" }, {
			icon = "",
			-- cond = function()
			-- 	return vim.b.gitsigns_status_dict ~= nil
			-- 		or vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true")
			-- end,
		})

		setup_plugin("gitsigns")
		local git_diff = {
			"diff",
			symbols = { added = "+", modified = "~", removed = "-" },
			colored = true,
			-- cond = function()
			-- 	return vim.b.gitsigns_status_dict ~= nil
			-- end,
			-- cond = function()
			-- 	return vim.b.gitsigns_head ~= nil
			-- end,
			padding = { left = 1, right = 1 },
		}

		local lsp_bubble = bubble(function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			local names = {}
			for _, c in ipairs(clients) do
				-- skip null-ls / none-ls noise, they show up separately
				if c.name ~= "null-ls" and c.name ~= "none-ls" then
					table.insert(names, c.name)
				end
			end
			return #names > 0 and ("󰒋 " .. table.concat(names, ", ")) or ""
		end, { fg = "#181825", bg = "#94e2d5" }, {
			cond = function()
				return #vim.lsp.get_clients({ bufnr = 0 }) > 0
			end,
		})

		local diagnostics_bubble = {
			"diagnostics",
			sources = { "nvim_lsp" },
			sections = { "error", "warn", "info", "hint" },
			symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
			colored = true,
			padding = { left = 1, right = 1 },
			cond = function()
				return #vim.lsp.get_clients({ bufnr = 0 }) > 0
			end,
		}

		-- ── Named sections ────────────────────────────────────────────────────────
		local mode_section = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		}
		local filename_section = {
			bubble("filename", { fg = "#cdd6f4", bg = "#45475a" }, {
				symbols = {
					modified = " ●",
					readonly = " ",
					unnamed = " [No Name]",
				},
			}),
		}
		local git_section = {
			"%=",
			git_bubble,
			git_diff,
			"%=",
			-- lsp_bubble,
			-- diagnostics_bubble,
			-- "%=",
		}
		local fileinfo_section = {
			bubble("filetype", { fg = "#181825", bg = "#b4befe" }, { icon_only = false }),
			bubble("encoding", { fg = "#181825", bg = "#585b70" }),
			bubble("fileformat", { fg = "#181825", bg = "#585b70" }, {
				symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
			}),
		}
		local location_section = {
			bubble("progress", { fg = "#181825", bg = "#a6adc8" }),
			{ "location", separator = { right = "" }, left_padding = 2 },
		}
		local navic_bubble = bubble(function()
			local ok, navic = pcall(require, "nvim-navic")
			if not ok or not navic.is_available() then
				return ""
			end
			return navic.get_location()
		end, { fg = "#181825", bg = "#f2cdcd" }, {
			cond = function()
				local ok, navic = pcall(require, "nvim-navic")
				return ok and navic.is_available()
			end,
		})
		local placeholder_section = {
			"%=",
			bubble(function()
				return "PLACEHOLDER"
			end, { fg = "#181825", bg = "#f2cdcd" }),
			"%=",
		}

		-- ── Config ────────────────────────────────────────────────────────────────
		local cfg = {
			options = {
				theme = bubbles_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
				globalstatus = true, -- single statusline across all windows
				refresh = { statusline = 100 },
			},

			sections = {
				lualine_a = mode_section,

				lualine_b = filename_section,

				-- Centre: git branch + diff + LSP name + diagnostics
				lualine_c = git_section,

				-- lualine_d = navic_section,

				-- lualine_w = placeholder_section,

				lualine_x = placeholder_section,

				lualine_y = fileinfo_section,

				lualine_z = location_section,
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{ "filename", color = { fg = "#6c7086" } },
				},
				lualine_x = {
					{ "location", color = { fg = "#6c7086" } },
				},
				lualine_y = {},
				lualine_z = {},
			},

			tabline = {},
			extensions = { "neo-tree", "quickfix", "toggleterm", "trouble" },
		}

		lualine.setup(cfg)
	end

	local function lualine_defaultlike(lualine)
		-- don't split bar; use single bar
		vim.o.laststatus = 3

		local cfg = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
					refresh_time = 16, -- ~60fps
					events = {
						"WinEnter",
						"BufEnter",
						"BufWritePost",
						"SessionLoadPost",
						"FileChangedShellPost",
						"VimResized",
						"Filetype",
						"CursorMoved",
						"CursorMovedI",
						"ModeChanged",
					},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		}
		lualine.setup(cfg)
	end

	local function lualine_other(lualine)
		local colors = {
			fg = "#aaaaaa",
			bg = "#153d21",
			blue = "#80a0ff",
			cyan = "#79dac8",
			black = "#080808",
			white = "#c6c6c6",
			red = "#ff5189",
			violet = "#d183e8",
			grey = "#303030",
			green = "#195510",
			orange = "#5b490d",
			red = "#650e0e",
		}
		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = {
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = "#636363", bg = "#122507" } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		local function insert_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function insert_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			buffer_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) == 1
			end,
			screen_width = function(min_w)
				return function()
					return vim.o.columns > min_w
				end
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
			diff_mode = function()
				return vim.o.diff == true
			end,
			-- ... other conditions
		}

		insert_left({
			"branch",
			icon = "",
			color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
		})

		insert_left({
			"diff",
			symbols = { added = " ", modified = " ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.screen_width(80),
		})

		insert_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				color_error = { fg = colors.red },
				color_warn = { fg = colors.yellow },
				color_info = { fg = colors.cyan },
			},
		})

		insert_left({
			function()
				return "%="
			end,
		})

		insert_right({
			"location",
			color = { fg = colors.fg_dark },
			cond = conditions.buffer_not_empty,
		})

		insert_right({
			"encoding",
		})

		insert_right({
			"filetype",
		})
	end

	-- setup_plugin("lualine", lualine_other)
	-- setup_plugin("lualine", lualine_bubbles)
	setup_plugin("lualine", lualine_defaultlike)
end

function setups.cokeline()
	setup_plugin("cokeline", {}) -- TODO
end

function setups.heirline()
	setup_plugin("heirline", {}) -- TODO
	setup_plugin("heirline-components", {}) -- TODO
end

function setups.galaxyline()
	setup_plugin("galaxyline", function(_) end) -- TODO
end

function setups.staline()
	setup_plugin("staline", {}) -- TODO
end

function setups.navic()
	-- https://github.com/SmiteshP/nvim-navic
	-- Simple winbar/statusline plugin that shows your current code context
	local navic_defaults = {
		icons = {
			File = "󰈙 ",
			Module = " ",
			Namespace = "󰌗 ",
			Package = " ",
			Class = "󰌗 ",
			Method = "󰆧 ",
			Property = " ",
			Field = " ",
			Constructor = " ",
			Enum = "󰕘",
			Interface = "󰕘",
			Function = "󰊕 ",
			Variable = "󰆧 ",
			Constant = "󰏿 ",
			String = "󰀬 ",
			Number = "󰎠 ",
			Boolean = "◩ ",
			Array = "󰅪 ",
			Object = "󰅩 ",
			Key = "󰌋 ",
			Null = "󰟢 ",
			EnumMember = " ",
			Struct = "󰌗 ",
			Event = " ",
			Operator = "󰆕 ",
			TypeParameter = "󰊄 ",
			enabled = true,
		},
		lsp = {
			auto_attach = false,
			preference = nil,
		},
		highlight = false,
		separator = " > ",
		depth_limit = 0,
		depth_limit_indicator = "..",
		safe_output = true,
		lazy_update_context = false,
		click = false,
		format_text = function(text)
			return text
		end,
	}
	setup_plugin("nvim-navic", navic_defaults)
end

function setups.bufferline()
	utils.packadd("nvim-web-devicons")
	-- https://github.com/akinsho/bufferline.nvim
	-- A snazzy bufferline for Neovim
	local BG = "#031A16"
	local FG = "#425c57"
	local NORMAL = {
		fg = FG,
		bg = BG,
	}
	local BRIGHT = {
		fg = "#ffffff",
		bg = BG, --"#0B342D",
		bold = true,
		italic = true,
	}
	local SAME = {
		fg = BG,
		bg = BG,
	}
	local bufferline_config = {
		highlights = {
			fill = NORMAL,
			background = NORMAL,
			tab = NORMAL,
			tab_selected = BRIGHT,
			tab_separator = SAME,
			tab_separator_selected = SAME,
			buffer_visible = NORMAL,
			buffer_selected = BRIGHT,
			tab_close = SAME,
			separator_selected = SAME,
			separator_visible = SAME,
			separator = SAME,
		},
		options = {

			mode = "buffers", -- set to "tabs" to only show tabpages instead
			-- commented out because depends on bufferline
			-- style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
			themable = true, -- | false, -- allows highlight groups to be overriden i.e. sets highlights as default
			numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
			close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
			right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
			left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
			middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
			indicator = {
				-- icon = " 👁️", --"▎", -- this should be omitted if indicator style is not 'icon'
				style = "none", -- | 'underline' | 'none' | 'icon',
			},
			buffer_close_icon = "", --"󰅖",
			modified_icon = "● ",
			close_icon = "", --" ",
			left_trunc_marker = " ",
			right_trunc_marker = " ",
			--- name_formatter can be used to change the buffer's label in the bufferline.
			--- Please note some names can/will break the
			--- bufferline so use this at your discretion knowing that it has
			--- some limitations that will *NOT* be fixed.
			name_formatter = function(buf) -- buf contains:
				-- name                | str        | the basename of the active file
				-- path                | str        | the full path of the active file
				-- bufnr               | int        | the number of the active buffer
				-- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
				-- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
			end,
			max_name_length = 18,
			max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
			truncate_names = true, -- whether or not tab names should be truncated
			tab_size = 18,
			diagnostics = false, -- | "nvim_lsp" | "coc",
			diagnostics_update_in_insert = false, -- only applies to coc
			diagnostics_update_on_event = true, -- use nvim's diagnostic handler
			-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				return "(" .. count .. ")"
			end,
			-- NOTE: this will be called a lot so don't do any heavy processing here
			custom_filter = function(buf_number, buf_numbers)
				-- filter out filetypes you don't want to see
				if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
					return true
				end
				-- filter out by buffer name
				if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
					return true
				end
				-- filter out based on arbitrary rules
				-- e.g. filter out vim wiki buffer from tabline in your work repo
				if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
					return true
				end
				-- filter out by it's index number in list (don't show first buffer)
				if buf_numbers[1] ~= buf_number then
					return true
				end
			end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer", -- | function ,
					text_align = "left", -- | "center" | "right"
					separator = true,
				},
			},
			color_icons = true, -- | false, -- whether or not to add the filetype icon highlights
			get_element_icon = function(element)
				-- element consists of {filetype: string, path: string, extension: string, directory: string}
				-- This can be used to change how bufferline fetches the icon
				-- for an element e.g. a buffer or a tab.
				-- e.g.
				local icon, hl =
					require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
				return icon, hl
				-- or
				-- local custom_map = {my_thing_ft: {icon = "my_thing_icon", hl}}
				-- return custom_map[element.filetype]
			end,
			show_buffer_icons = true, -- | false, -- disable filetype icons for buffers
			show_buffer_close_icons = false, -- | false,
			show_close_icon = false, -- | false,
			show_tab_indicators = true, -- | false,
			show_duplicate_prefix = true, -- | false, -- whether to show duplicate buffer prefix
			duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
			-- can also be a table containing 2 custom separators
			-- [focused and unfocused]. eg: { '|', '|' }
			separator_style = nil, -- | "slope" | "thick" | "thin" | { "any", "any" },
			enforce_regular_tabs = false, -- | true,
			always_show_bufferline = false, -- | false,
			auto_toggle_bufferline = true, -- | false,
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
			sort_by = "insert_after_current",
			-- | "insert_at_end"
			-- | "id"
			-- | "extension"
			-- | "relative_directory"
			-- | "directory"
			-- | "tabs"
			-- | function(buffer_a, buffer_b)
			-- 	-- add custom logic
			-- 	local modified_a = vim.fn.getftime(buffer_a.path)
			-- 	local modified_b = vim.fn.getftime(buffer_b.path)
			-- 	return modified_a > modified_b
			-- end,
			pick = {
				alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
			},
		},
	}
	setup_plugin("bufferline", function(bufferline)
		bufferline.setup(bufferline_config)
	end)
end

setups["nougat-tabline"] = function()
	-- https://github.com/MunifTanjim/nougat.nvim
	-- Hyperextensible Statusline / Tabline / Winbar for Neovim
	setup_plugin("nougat", function(_) end) -- TODO
end

setups["nougat-statusline"] = function()
	-- https://github.com/MunifTanjim/nougat.nvim
	-- Hyperextensible Statusline / Tabline / Winbar for Neovim
	setup_plugin("nougat", function(_) end) -- TODO
end

setups["nougat-winbar"] = function()
	-- https://github.com/MunifTanjim/nougat.nvim
	-- Hyperextensible Statusline / Tabline / Winbar for Neovim
	setup_plugin("nougat", function(_) end) -- TODO
end

function setups.tabby()
	--
	--
	setup_plugin("tabby", {}) -- TODO
end

function setups.minibar()
	-- https://github.com/aktersnurra/minibar.nvim
	-- A minimalistic winbar.
	local cfg = {
		["ignore-filetypes"] = {
			"help",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"NvimTree",
			"Trouble",
			"alpha",
			"lir",
			"Outline",
			"NeogitStatus",
			"NeogitCommitMessage",
			"NeogitNotification",
			"NeogitCommitView",
			"spectre_panel",
		},
		["events"] = {
			"CursorMoved",
			"CursorHold",
			"BufWinEnter",
			"BufFilePost",
			"InsertEnter",
			"BufWritePost",
			"TabClosed",
		},
	}
	setup_plugin("minibar", cfg)
end

function setups.winbar()
	-- https://github.com/fgheng/winbar.nvim
	-- winbar config for neovim
	local cfg = {
		enabled = true,

		show_file_path = true,
		show_symbols = true,

		colors = {
			path = "", -- You can customize colors like #c946fd
			file_name = "",
			symbols = "",
		},

		icons = {
			file_icon_default = "",
			seperator = ">",
			editor_state = "●",
			lock_icon = "",
		},

		exclude_filetype = {
			"help",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"NvimTree",
			"Trouble",
			"alpha",
			"lir",
			"Outline",
			"spectre_panel",
			"toggleterm",
			"qf",
		},
	}
	setup_plugin("winbar", cfg)
end

function setups.windline()
	setup_plugin("windline", function(windline)
		local windline = require("windline")
		local helper = require("windline.helpers")
		local sep = helper.separators
		local vim_components = require("windline.components.vim")

		local b_components = require("windline.components.basic")
		local state = _G.WindLine.state

		local lsp_comps = require("windline.components.lsp")
		local git_comps = require("windline.components.git")

		local hl_list = {
			Black = { "white", "black" },
			White = { "black", "white" },
			Inactive = { "InactiveFg", "InactiveBg" },
			Active = { "ActiveFg", "ActiveBg" },
		}
		local basic = {}

		basic.divider = { b_components.divider, "" }
		basic.file_name_inactive = { b_components.full_file_name, hl_list.Inactive }
		basic.line_col_inactive = { b_components.line_col, hl_list.Inactive }
		basic.progress_inactive = { b_components.progress, hl_list.Inactive }

		basic.vi_mode = {
			name = "vi_mode",
			hl_colors = {
				Normal = { "black", "red", "bold" },
				Insert = { "black", "green", "bold" },
				Visual = { "black", "yellow", "bold" },
				Replace = { "black", "blue_light", "bold" },
				Command = { "black", "magenta", "bold" },
				NormalBefore = { "red", "black" },
				InsertBefore = { "green", "black" },
				VisualBefore = { "yellow", "black" },
				ReplaceBefore = { "blue_light", "black" },
				CommandBefore = { "magenta", "black" },
				NormalAfter = { "white", "red" },
				InsertAfter = { "white", "green" },
				VisualAfter = { "white", "yellow" },
				ReplaceAfter = { "white", "blue_light" },
				CommandAfter = { "white", "magenta" },
			},
			text = function()
				return {
					{ sep.left_rounded, state.mode[2] .. "Before" },
					{ state.mode[1] .. " ", state.mode[2] },
					{ sep.left_rounded, state.mode[2] .. "After" },
				}
			end,
		}

		basic.lsp_diagnos = {
			name = "diagnostic",
			hl_colors = {
				red = { "red", "black" },
				yellow = { "yellow", "black" },
				blue = { "blue", "black" },
			},
			width = 90,
			text = function(bufnr)
				if lsp_comps.check_lsp(bufnr) then
					return {
						{ lsp_comps.lsp_error({ format = "  %s" }), "red" },
						{ lsp_comps.lsp_warning({ format = "  %s" }), "yellow" },
						{ lsp_comps.lsp_hint({ format = "  %s" }), "blue" },
					}
				end
				return ""
			end,
		}

		basic.file = {
			name = "file",
			hl_colors = {
				default = hl_list.White,
			},
			text = function()
				return {
					{ b_components.cache_file_icon({ default = "" }), "default" },
					{ " ", "default" },
					{ b_components.cache_file_name("[No Name]", "unique") },
					{ b_components.file_modified(" ") },
					{ b_components.cache_file_size() },
				}
			end,
		}

		basic.right = {
			hl_colors = {
				sep_before = { "black_light", "black" },
				sep_after = { "black_light", "black" },
				text = { "white", "black_light" },
			},
			text = function()
				return {
					{ sep.left_rounded, "sep_before" },
					{ "l/n", "text" },
					{ b_components.line_col_lua },
					{ "" },
					{ b_components.progress_lua },
					{ sep.right_rounded, "sep_after" },
				}
			end,
		}
		basic.git = {
			name = "git",
			width = 90,
			hl_colors = {
				green = { "green", "black" },
				red = { "red", "black" },
				blue = { "blue", "black" },
			},
			text = function(bufnr)
				if git_comps.is_git(bufnr) then
					return {
						{ " " },
						{ git_comps.diff_added({ format = " %s" }), "green" },
						{ git_comps.diff_removed({ format = "  %s" }), "red" },
						{ git_comps.diff_changed({ format = "  %s" }), "blue" },
					}
				end
				return ""
			end,
		}

		local default = {
			filetypes = { "default" },
			active = {
				{ " ", hl_list.Black },
				basic.vi_mode,
				basic.file,
				{ vim_components.search_count(), { "red", "white" } },
				{ sep.right_rounded, hl_list.Black },
				basic.lsp_diagnos,
				basic.git,
				basic.divider,
				{ git_comps.git_branch({ icon = "  " }), { "green", "black" }, 90 },
				{ " ", hl_list.Black },
				basic.right,
				{ " ", hl_list.Black },
			},
			inactive = {
				basic.file_name_inactive,
				basic.divider,
				basic.divider,
				basic.line_col_inactive,
				{ "", hl_list.Inactive },
				basic.progress_inactive,
			},
		}

		local quickfix = {
			filetypes = { "qf", "Trouble" },
			active = {
				{ "🚦 Quickfix ", { "white", "black" } },
				{ helper.separators.slant_right, { "black", "black_light" } },
				{
					function()
						return vim.fn.getqflist({ title = 0 }).title
					end,
					{ "cyan", "black_light" },
				},
				{ " Total : %L ", { "cyan", "black_light" } },
				{ helper.separators.slant_right, { "black_light", "InactiveBg" } },
				{ " ", { "InactiveFg", "InactiveBg" } },
				basic.divider,
				{ helper.separators.slant_right, { "InactiveBg", "black" } },
				{ "🧛 ", { "white", "black" } },
			},
			always_active = true,
			show_last_status = true,
		}

		local explorer = {
			filetypes = { "fern", "NvimTree", "lir" },
			active = {
				{ "  ", { "white", "black_light" } },
				{ helper.separators.slant_right, { "black_light", "NormalBg" } },
				{ b_components.divider, "" },
				{ b_components.file_name(""), { "NormalFg", "NormalBg" } },
			},
			always_active = true,
			show_last_status = true,
		}

		windline.setup({
			colors_name = function(colors)
				-- ADD MORE COLOR HERE ----
				return colors
			end,
			statuslines = {
				default,
				explorer,
				quickfix,
			},
		})
	end)
end

--─────────────────────────────────────────────────────────────────────────────
--──── focus ──────────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.vimade()
	-- https://github.com/tadaa/vimade
	-- Vimade let's you dim, fade, tint, animate, and customize colors in your windows and buffers for (Neo)vim
	setup_plugin("vimade", {
		recipe = { "default", { animate = true } },
		fadelevel = 0.4,
	})
end

function setups.zenmode()
	-- https://github.com/folke/zen-mode.nvim
	-- Distraction-free coding for Neovim
	local zenmode_defaults = {
		wezterm = {
			enabled = true,
			-- can be either an absolute font size or the number of incremental steps
			font = "+4", -- (10% increase per step)
		},
	}
	setup_plugin("zen-mode", function(zenmode)
		zenmode.setup(zenmode_defaults)

		map_explicit({
			mode = "n",
			sequence = "<leader>zm",
			action = function()
				-- width will be 85% of the editor width
				zenmode.toggle({ window = { width = 0.85 } })
			end,
			desc = "",
		})
		-- print("set map")
	end)
end

--─────────────────────────────────────────────────────────────────────────────
--──── mode-related ───────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.modicator()
	-- https://github.com/mawkler/modicator.nvim
	-- Cursor line number mode indicator plugin for Neovim
	local modicator_defaults = {
		-- Warn if any required option is missing. May emit false positives if some
		-- other plugin modifies them, which in that case you can just ignore
		show_warnings = false,
		highlights = {
			-- Default options for bold/italic
			defaults = {
				bold = false,
				italic = false,
			},
			-- Use `CursorLine`'s background color for `CursorLineNr`'s background
			use_cursorline_background = false,
		},
		integration = {
			lualine = {
				enabled = true,
				-- Letter of lualine section to use (if `nil`, gets detected automatically)
				mode_section = nil,
				-- Whether to use lualine's mode highlight's foreground or background
				highlight = "bg",
			},
		},
	}
	setup_plugin("modicator", function(modicator)
		-- already selected in options.lua
		-- vim.o.termguicolors = true
		-- vim.o.cursorline = true
		-- vim.o.number = true
		modicator.setup(modicator_defaults)
	end)
end

function setups.modes()
	-- https://github.com/mvllow/modes.nvim
	-- Prismatic line decorations for the adventurous vim user
	local modes_defaults = {
		colors = {
			bg = "", -- Optional bg param, defaults to Normal hl group
			copy = "#f5c359",
			delete = "#c75c6a",
			change = "#c75c6a", -- Optional param, defaults to delete
			format = "#c79585",
			insert = "#78ccc5",
			replace = "#245361",
			select = "#9745be", -- Optional param, defaults to visual
			visual = "#9745be",
		},

		-- Set opacity for cursorline and number background
		line_opacity = 0.15,

		-- Enable cursor highlights
		set_cursor = true,

		-- Enable cursorline initially, and disable cursorline for inactive windows
		-- or ignored filetypes
		set_cursorline = true,

		-- Enable line number highlights to match cursorline
		set_number = true,

		-- Enable sign column highlights to match cursorline
		set_signcolumn = true,

		-- Disable modes highlights for specified filetypes
		-- or enable with prefix "!" if otherwise disabled (please PR common patterns)
		-- Can also be a function fun():boolean that disables modes highlights when true
		ignore = { "NvimTree", "TelescopePrompt", "!minifiles" },
	}
	setup_plugin("modes", function(modes)
		modes.setup(modes_defaults)
		vim.o.cmdheight = 0
	end)
end

--─────────────────────────────────────────────────────────────────────────────
--──── command interface ──────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.cmdbuf()
	-- PROBABLY NOT, BUT WORTH A TRY
	-- https://github.com/notomo/cmdbuf.nvim
	-- Alternative command-line window plugin for neovim
	local cmdbuf_defaults = nil
	setup_plugin("cmdbuf", function(cmdbuf)
		map_explicit({
			mode = "n",
			sequence = "q:",
			action = function()
				cmdbuf.split_open(vim.o.cmdwinheight)
			end,
		})
		map_explicit({
			mode = "c",
			sequence = "<C-f>",
			action = function()
				cmdbuf.split_open(vim.o.cmdwinheight, { line = vim.fn.getcmdline(), column = vim.fn.getcmdpos() })
				vim.api.nvim_feedkeys(vim.keycode("<C-c>"), "n", true)
			end,
		})

		-- Custom buffer mappings
		vim.api.nvim_create_autocmd({ "User" }, {
			group = vim.api.nvim_create_augroup("config.cmdbuf", {}),
			pattern = { "CmdbufNew" },
			callback = function(args)
				vim.bo.bufhidden = "wipe" -- if you don't need previous opened buffer state
				map_explicit({
					mode = "n",
					"q",
					[[<Cmd>quit<CR>]],
					opts = { nowait = true, buf = 0 },
				})
				map_explicit({
					mode = "n",
					"dd",
					[[<Cmd>lua require('cmdbuf').delete()<CR>]],
					opts = { buf = 0 },
				})
				map_explicit({
					mode = { "n", "i" },
					"<C-c>",
					function()
						return cmdbuf.cmdline_expr()
					end,
					opts = { buf = 0, expr = true },
				})

				local typ = cmdbuf.get_context().type
				if typ == "vim/cmd" then
					-- you can filter buffer lines
					local lines = vim.iter(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false))
						:filter(function(line)
							return line ~= "q"
						end)
						:totable()
					vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
				end
			end,
		})

		-- open lua command-line window
		map_explicit({
			mode = "n",
			sequence = "ql",
			action = function()
				cmdbuf.split_open(vim.o.cmdwinheight, { type = "lua/cmd" })
			end,
		})

		-- q/, q? alternative
		map_explicit({
			mode = "n",
			sequence = "q/",
			action = function()
				cmdbuf.split_open(vim.o.cmdwinheight, { type = "vim/search/forward" })
			end,
		})
		map_explicit({
			mode = "n",
			sequence = "q?",
			action = function()
				cmdbuf.split_open(vim.o.cmdwinheight, { type = "vim/search/backward" })
			end,
		})
	end)
end

setups["mini-cmdline"] = function()
	-- https://github.com/nvim-mini/mini.cmdline
	-- Command line tweaks. Part of 'mini.nvim' library.
	local mini_cmdline_defaults = {
		-- Autocompletion: show `:h 'wildmenu'` as you type
		autocomplete = {
			enable = true,

			-- Delay (in ms) after which to trigger completion
			-- Neovim>=0.12 is recommended for positive values
			delay = 0,

			-- Custom rule of when to trigger completion
			predicate = nil,

			-- Whether to map arrow keys for more consistent wildmenu behavior
			map_arrows = true,
		},

		-- Autocorrection: adjust non-existing words (commands, options, etc.)
		autocorrect = {
			enable = true,

			-- Custom autocorrection rule
			func = nil,
		},

		-- Autopeek: show command's target range in a floating window
		autopeek = {
			enable = true,

			-- Number of lines to show above and below range lines
			n_context = 1,

			-- Custom rule of when to show peek window
			predicate = nil,

			-- Window options
			window = {
				-- Floating window config
				config = {},

				-- Function to render statuscolumn
				statuscolumn = nil,
			},
		},
	}
	setup_plugin("mini.cmdline", mini_cmdline_defaults)
end

--─────────────────────────────────────────────────────────────────────────────
--──── menus, selection ───────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.menu()
	-- https://github.com/nvzone/menu
	-- Menu plugin for neovim ( supports nested menus ) made using volt
	local menu_defaults = nil
	setup_plugin("menu") -- testing only; usable as a library
end

--─────────────────────────────────────────────────────────────────────────────
--──── output, notification ───────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.fidget()
	-- https://github.com/j-hui/fidget.nvim
	-- Extensible UI for Neovim notifications and LSP progress messages.
	local fidget_defaults = [[{
	-- Options related to LSP progress subsystem
	progress = {
		poll_rate = 0, -- How and when to poll for progress messages
		suppress_on_insert = false, -- Suppress new messages while in insert mode
		ignore_done_already = false, -- Ignore new tasks that are already complete
		ignore_empty_message = false, -- Ignore new tasks that don't contain a message
		-- Clear notification group when LSP server detaches
		clear_on_detach = function(client_id)
			local client = vim.lsp.get_client_by_id(client_id)
			return client and client.name or nil
		end,
		-- How to get a progress message's notification group key
		notification_group = function(msg)
			return msg.lsp_client.name
		end,
		ignore = {}, -- List of LSP servers to ignore

		-- Options related to how LSP progress messages are displayed as notifications
		display = {
			render_limit = 16, -- How many LSP messages to show at once
			done_ttl = 3, -- How long a message should persist after completion
			done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
			done_style = "Constant", -- Highlight group for completed LSP tasks
			progress_ttl = math.huge, -- How long a message should persist when in progress
			-- Icon shown when LSP progress tasks are in progress
			progress_icon = { "dots" },
			-- Highlight group for in-progress LSP tasks
			progress_style = "WarningMsg",
			group_style = "Title", -- Highlight group for group name (LSP server name)
			icon_style = "Question", -- Highlight group for group icons
			priority = 30, -- Ordering priority for LSP notification group
			skip_history = true, -- Whether progress notifications should be omitted from history
			-- How to format a progress message
			format_message = require("fidget.progress.display").default_format_message,
			-- How to format a progress annotation
			format_annote = function(msg)
				return msg.title
			end,
			-- How to format a progress notification group's name
			format_group_name = function(group)
				return tostring(group)
			end,
			overrides = { -- Override options from the default notification config
				rust_analyzer = { name = "rust-analyzer" },
			},
		},

		-- Options related to Neovim's built-in LSP client
		lsp = {
			progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
			log_handler = false, -- Log `$/progress` handler invocations (for debugging)
		},
	},

	-- Options related to notification subsystem
	notification = {
		poll_rate = 10, -- How frequently to update and render notifications
		filter = vim.log.levels.INFO, -- Minimum notifications level
		history_size = 128, -- Number of removed messages to retain in history
		override_vim_notify = false, -- Automatically override vim.notify() with Fidget
		-- How to configure notification groups when instantiated
		configs = { default = require("fidget.notification").default_config },
		-- Conditionally redirect notifications to another backend
		redirect = function(msg, level, opts)
			if opts and opts.on_open then
				return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
			end
		end,

		-- Options related to how notifications are rendered as text
		view = {
			stack_upwards = true, -- Display notification items from bottom to top
			align = "message", -- Indent messages longer than a single line
			reflow = false, -- Reflow (wrap) messages wider than notification window
			icon_separator = " ", -- Separator between group name and icon
			group_separator = "---", -- Separator between notification groups
			-- Highlight group used for group separator
			group_separator_hl = "Comment",
			line_margin = 1, -- Spaces to pad both sides of each non-empty line
			-- How to render notification messages
			render_message = function(msg, cnt)
				return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
			end,
		},

		-- Options related to the notification window and buffer
		window = {
			normal_hl = "Comment", -- Base highlight group in the notification window
			winblend = 100, -- Background color opacity in the notification window
			border = "none", -- Border around the notification window
			zindex = 45, -- Stacking priority of the notification window
			max_width = 0, -- Maximum width of the notification window
			max_height = 0, -- Maximum height of the notification window
			x_padding = 1, -- Padding from right edge of window boundary
			y_padding = 0, -- Padding from bottom edge of window boundary
			align = "bottom", -- How to align the notification window
			relative = "editor", -- What the notification window position is relative to
			tabstop = 8, -- Width of each tab character in the notification window
			avoid = {}, -- Filetypes the notification window should avoid
			-- e.g., { "aerial", "NvimTree", "neotest-summary" }
		},
	},

	-- Options related to integrating with other plugins
	integration = {
		["nvim-tree"] = {
			enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
			-- DEPRECATED; use notification.window.avoid = { "NvimTree" }
		},
		["xcodebuild-nvim"] = {
			enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
			-- DEPRECATED; use notification.window.avoid = { "TestExplorer" }
		},
	},

	-- Options related to logging
	logger = {
		level = vim.log.levels.WARN, -- Minimum logging level
		max_size = 10000, -- Maximum log file size, in KB
		float_precision = 0.01, -- Limit the number of decimals displayed for floats
		-- Where Fidget writes its logs to
		path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
	},
	}]]
	setup_plugin("fidget", {
		notification = {
			window = {
				winblend = 0,
			},
		},
		progress = {
			suppress_on_insert = false,
		},
	})
end

function setups.notify()
	-- PROBABLY NOT, BUT WORTH A TRY (== nvim-notify ?)
	-- https://github.com/rcarriga/nvim-notify
	-- A fancy, configurable, notification manager for NeoVim
	local notify_defaults = {
		stages = "fade",
		timeout = 3000,
		render = "wrapped-default",
		max_width = function()
			return math.floor(vim.o.columns * 0.4)
		end,
	}
	vim.opt.termguicolors = true
	-- highlight NotifyERRORBorder guifg=#8A1F1F
	-- highlight NotifyWARNBorder guifg=#79491D
	-- highlight NotifyINFOBorder guifg=#4F6752
	-- highlight NotifyDEBUGBorder guifg=#8B8B8B
	-- highlight NotifyTRACEBorder guifg=#4F3552
	-- highlight NotifyERRORIcon guifg=#F70067
	-- highlight NotifyWARNIcon guifg=#F79000
	-- highlight NotifyINFOIcon guifg=#A9FF68
	-- highlight NotifyDEBUGIcon guifg=#8B8B8B
	-- highlight NotifyTRACEIcon guifg=#D484FF
	-- highlight NotifyERRORTitle  guifg=#F70067
	-- highlight NotifyWARNTitle guifg=#F79000
	-- highlight NotifyINFOTitle guifg=#A9FF68
	-- highlight NotifyDEBUGTitle  guifg=#8B8B8B
	-- highlight NotifyTRACETitle  guifg=#D484FF
	-- highlight link NotifyERRORBody Normal
	-- highlight link NotifyWARNBody Normal
	-- highlight link NotifyINFOBody Normal
	-- highlight link NotifyDEBUGBody Normal
	-- highlight link NotifyTRACEBody Normal
	setup_plugin("notify", function(notify)
		notify.setup(notify_defaults)

		vim.notify = notify
	end)
end

setups["control-panel"] = function()
	-- https://github.com/mhanberg/control-panel.nvim
	-- experimental plugin, use with caution
	local control_panel_defaults = nil
	setup_plugin("control_panel", control_panel_defaults)
end

setups["output-panel"] = function()
	-- TODO: translate lazy.nvim options from README
	-- https://github.com/mhanberg/output-panel.nvim
	-- A panel to view the logs from your LSP servers.
	local output_panel_defaults = {
		max_buffer_size = 5000, -- default
	}
	setup_plugin("output_panel", output_panel_defaults)
end

--─────────────────────────────────────────────────────────────────────────────
--──── UI libraries ───────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.cosmicui()
	-- https://github.com/CosmicNvim/cosmic-ui
	-- Cosmic-UI is a simple wrapper around specific vim functionality. Built in order to provide a quick and easy way to create a Cosmic UI experience with Neovim!
	local cosmic_ui_defaults = {
		notify_title = "CosmicUI",

		rename = {
			enabled = true, -- optional (defaults to true when table exists)
			border = {
				highlight = "FloatBorder",
				style = nil, -- falls back to vim.o.winborder
				title = "Rename",
				title_align = "left",
				title_hl = "FloatBorder",
			},
			prompt = "> ",
			prompt_hl = "Comment",
		},

		codeactions = {
			enabled = true, -- optional (defaults to true when table exists)
			min_width = nil,
			border = {
				bottom_hl = "FloatBorder",
				highlight = "FloatBorder",
				style = nil, -- falls back to vim.o.winborder
				title = "Code Actions",
				title_align = "center",
				title_hl = "FloatBorder",
			},
		},

		formatters = {
			enabled = true, -- optional (defaults to true when table exists)
		},
	}
	setup_plugin("cosmic-ui", cosmic_ui_defaults)
end

setups["lvim-ui-config"] = function()
	--
	--
	setup_plugin("lvim-ui-config", {}) -- TODO: not requirable
end

function setups.volt()
	-- https://github.com/nvzone/volt
	-- Create blazing fast & beautiful reactive UI in Neovim
	setup_plugin("volt", function(_) end)
end

function setups.noice()
	-- https://github.com/folke/noice.nvim
	-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
	local noice_config = {
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
	}
	setup_plugin("noice", noice_config)
end
--─────────────────────────────────────────────────────────────────────────────
--──── other/general ──────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

function setups.reactive()
	-- https://github.com/rasulomaroff/reactive.nvim
	-- Reactivity. Right in your neovim.
	local reactive_config = { -- TODO; not currently using this so I can explore
		builtin = {},
		configs = {},
		load = {},
	}
	setup_plugin("reactive")

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "markdown", "norg" },
		callback = function()
			vim.opt_local.conceallevel = 2
		end,
	})
end

--─────────────────────────────────────────────────────────────────────────────
--──── SETUP ──────────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

-- local functions = {
-- 	["nvim-web-devicons"] = setup_icons,
-- 	["virtcolumn"] = setup_virtcolumn,
-- 	["virt-column"] = setup_virt_column,
-- 	["smartcolumn"] = setup_smartcolumn,
-- 	["statuscol"] = setup_statuscol,
-- 	["TreePin"] = setup_treepin,
-- 	["symbols"] = setup_symbols,
-- 	["aerial"] = setup_aerial,
-- 	["navbuddy"] = setup_navbuddy,
-- 	["dropbar"] = setup_dropbar,
-- 	["lualine"] = setup_lualine,
-- 	["cokeline"] = setup_cokeline,
-- 	["heirline"] = setup_heirline,
-- 	["galaxyline"] = setup_galaxyline,
-- 	["staline"] = setup_staline,
-- 	["navic"] = setup_navic,
-- 	["bufferline"] = setup_bufferline,
-- 	["nougat::statusline"] = setup_nougat_statusline,
-- 	["nougat::tabline"] = setup_nougat_tabline,
-- 	["nougat::winbar"] = setup_nougat_winbar,
-- 	["tabby"] = setup_tabby,
-- 	["minibar"] = setup_minibar,
-- 	["winbar"] = setup_winbar,
-- 	["windline"] = setup_windline,
-- 	["vimade"] = setup_vimade,
-- 	["zen-mode"] = setup_zenmode,
-- 	["modicator"] = setup_modicator,
-- 	["modes"] = setup_modes,
-- 	["cmdbuf"] = setup_cmdbuf,
-- 	["mini.cmdline"] = setup_mini_cmdline,
-- 	["menu"] = setup_menu,
-- 	["fidget"] = setup_fidget,
-- 	["notify"] = setup_notify,
-- 	["control-panel"] = setup_control_panel,
-- 	["output-panel"] = setup_output_panel,
-- 	["cosmic-ui"] = setup_cosmicui,
-- 	["lvim-ui-config"] = setup_lvim_ui_config,
-- 	["volt"] = setup_volt,
-- 	["noice"] = setup_noice,
-- 	["reactive"] = setup_reactive,
-- }

-- local function maybe_setup(plugin_name)
-- 	local include = plugins[plugin_name]
-- 	if include then
-- 		-- print("Setting up " .. plugin_name)
-- 		local func = functions[plugin_name]
-- 		func()
-- 	end
-- end

-- maybe_setup("nvim-web-devicons")
-- maybe_setup("virtcolumn")
-- maybe_setup("virt-column")
-- maybe_setup("smartcolumn")
-- maybe_setup("statuscol")
-- maybe_setup("TreePin")
-- maybe_setup("symbols")
-- maybe_setup("aerial")
-- maybe_setup("navbuddy")
-- maybe_setup("dropbar")
-- maybe_setup("lualine")
-- maybe_setup("cokeline")
-- maybe_setup("heirline")
-- maybe_setup("galaxyline")
-- maybe_setup("staline")
-- maybe_setup("navic")
-- maybe_setup("bufferline")
-- maybe_setup("nougat::statusline")
-- maybe_setup("nougat::tabline")
-- maybe_setup("nougat::winbar")
-- maybe_setup("tabby")
-- maybe_setup("minibar")
-- maybe_setup("winbar")
-- maybe_setup("windline")
-- maybe_setup("vimade")
-- maybe_setup("zen-mode")
-- maybe_setup("modicator")
-- maybe_setup("modes")
-- maybe_setup("cmdbuf")
-- maybe_setup("mini.cmdline")
-- maybe_setup("menu")
-- maybe_setup("fidget")
-- maybe_setup("notify")
-- maybe_setup("control-panel")
-- maybe_setup("output-panel")
-- maybe_setup("cosmic-ui")
-- maybe_setup("lvim-ui-config")
-- maybe_setup("volt")
-- maybe_setup("noice")
-- maybe_setup("reactive")

setup_all_enabled("ui", setups)
