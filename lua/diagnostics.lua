-- quicker and bqf work well together, from what I can tell
-- trouble does its own thing, but is improved by quicker
--

local setups = {}

function setups.create_keymaps()
	local lsp_map_opts = { buffer = bufnr, silent = true }

	map_explicit({
		mode = "n",
		sequence = "<leader>ql",
		action = function()
			-- Populates the Quickfix list with all diagnostics from the current buffer
			vim.diagnostic.setqflist({ bufnr = 0 })
			vim.cmd("copen")
		end,
		desc = "Open Quickfix with diagnostics",
	})

	-- map_explicit({
	-- 	mode = "n",
	-- 	sequence = "<leader>ql",
	-- 	action = function()
	-- 		-- Populates the Quickfix list with all diagnostics from the current buffer
	-- 		vim.diagnostic.setqflist({ bufnr = 0 })
	-- 		vim.cmd("copen")
	-- 	end,
	-- 	desc = "Open Quickfix with diagnostics",
	-- })

	--[[
    :copen    " open the quickfix window
    :cn       " next error
    :cp       " previous error  
    :cc       " jump to current entry
    --]]
end

-- TODO: remove duplication in keymaps
function setups.create_autocommands()
	local function on_attach(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		local shared_opts = { buffer = ev.buf, silent = true }
		map_explicit({
			mode = "n",
			sequence = "gd",
			action = vim.lsp.buf.definition,
			opts = shared_opts,
		})
		map_explicit({
			mode = "n",
			sequence = "K",
			action = vim.lsp.buf.hover,
			opts = shared_opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>rn",
			action = vim.lsp.buf.rename,
			opts = shared_opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>ca",
			action = vim.lsp.buf.code_action,
			opts = shared_opts,
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>cl",
			action = vim.lsp.codelens.run,
			opts = shared_opts,
		})
	end

	vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

	-- LSP KEYMAPS
	-- autocommand group to attach keymaps only to buffers with an active LSP client.
	local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = lsp_keymaps_group,
		callback = function(ev)
			local lsp_map = function(keys, func, desc)
				map_explicit({
					mode = "n",
					sequence = keys,
					action = func,
					opts = { buffer = ev.buf, desc = "LSP: " .. desc },
				})
			end

			-- Navigation and Information
			lsp_map("gd", vim.lsp.buf.definition, "Go to Definition")
			lsp_map("gD", vim.lsp.buf.declaration, "Go to Declaration")
			lsp_map("gr", vim.lsp.buf.references, "Go to References")
			lsp_map("gI", vim.lsp.buf.implementation, "Go to Implementation")
			lsp_map("K", vim.lsp.buf.hover, "Hover Documentation")
			lsp_map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

			-- Actions
			lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action") -- TODO: duplicate
			lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")

			-- Diagnostics
			lsp_map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
			lsp_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
			lsp_map("<leader>dl", vim.diagnostic.open_float, "Show Line Diagnostics")

			-- format on save (to use LSP formatter instead of conform)
			-- vim.api.nvim_buf_create_autocmd("BufWritePre", {
			--   buffer = ev.buf,
			--   callback = function() vim.lsp.buf.format { async = false } end
			-- })
			--
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
		end,
	})

	-- TODO: check duplication; fold into above
	local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = lsp_keymaps_group,
		callback = function(ev)
			local lsp_map = function(keys, func, desc)
				map_explicit({
					mode = "n",
					sequence = keys,
					action = func,
					opts = { buffer = ev.buf, desc = "LSP: " .. desc },
				})
			end

			-- Navigation and Information
			lsp_map("gd", vim.lsp.buf.definition, "Go to Definition")
			lsp_map("gD", vim.lsp.buf.declaration, "Go to Declaration")
			lsp_map("gr", vim.lsp.buf.references, "Go to References")
			lsp_map("gI", vim.lsp.buf.implementation, "Go to Implementation")
			lsp_map("K", vim.lsp.buf.hover, "Hover Documentation")
			lsp_map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

			-- Actions
			lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")

			-- Diagnostics
			lsp_map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
			lsp_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
			lsp_map("<leader>dl", vim.diagnostic.open_float, "Show Line Diagnostics")

			-- format on save (to use LSP formatter instead of conform)
			-- vim.api.nvim_buf_create_autocmd("BufWritePre", {
			--   buffer = ev.buf,
			--   callback = function() vim.lsp.buf.format { async = false } end
			-- })
			--
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
		end,
	})
end

function setups.diagflow()
	-- https://github.com/dgagn/diagflow.nvim
	-- LSP diagnostics in virtual text at the top right of your screen
	local diagflow_defaults = {
		enable = true,
		max_width = 60, -- The maximum width of the diagnostic messages
		max_height = 10, -- the maximum height per diagnostics
		severity_colors = { -- The highlight groups to use for each diagnostic severity level
			error = "DiagnosticFloatingError",
			warning = "DiagnosticFloatingWarn",
			info = "DiagnosticFloatingInfo",
			hint = "DiagnosticFloatingHint",
		},
		format = function(diagnostic)
			return diagnostic.message
		end,
		gap_size = 1,
		scope = "cursor", -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
		padding_top = 0,
		padding_right = 0,
		text_align = "right", -- 'left', 'right'
		placement = "top", -- 'top', 'inline'
		inline_padding_left = 0, -- the padding left when the placement is inline
		update_event = { "DiagnosticChanged", "BufReadPost" }, -- the event that updates the diagnostics cache
		toggle_event = {}, -- if InsertEnter, can toggle the diagnostics on inserts
		show_sign = false, -- set to true if you want to render the diagnostic sign before the diagnostic message
		render_event = { "DiagnosticChanged", "CursorMoved" },
		border_chars = {
			top_left = "┌",
			top_right = "┐",
			bottom_left = "└",
			bottom_right = "┘",
			horizontal = "─",
			vertical = "│",
		},
		show_borders = false,
	}
	setup_plugin("diagflow", diagflow_defaults)
end

function setups.configure_diagnostics_modes()
	current_mode_index = 1
	diagnostics_active = false

	vim.g.diagnostic_modes = {
		{
			name = "End of Line (Virtual Text)",
			config = {
				virtual_text = {
					prefix = "●", -- Could be '■', '▎', 'x'
					spacing = 4,
					source = "if_many",
				},
				virtual_lines = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
			},
		},
		{
			name = "Under Line (Virtual Lines)",
			config = {
				virtual_text = false,
				-- 'virtual_lines' is now a built-in handler in Nvim 0.10/0.11+
				virtual_lines = {
					only_current_line = true, -- Only show for current line to reduce clutter
					highlight_whole_line = false,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
			},
		},
		{
			name = "Gutter Only (Signs)",
			config = {
				virtual_text = false,
				virtual_lines = false,
				signs = {
					-- Custom mapping for signs if you want specific characters
					text = {
						[vim.diagnostic.severity.ERROR] = "E",
						[vim.diagnostic.severity.WARN] = "W",
						[vim.diagnostic.severity.HINT] = "H",
						[vim.diagnostic.severity.INFO] = "I",
					},
				},
				underline = false, -- Often cleaner to disable underline in "minimal" mode
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
			},
		},
	}

	local function set_diagnostics_mode()
		if not diagnostics_active then
			vim.diagnostic.enable(false)
			utils.printv("LSP Diagnostics: OFF")
			return
		end

		vim.diagnostic.enable(true)
		local mode = vim.g.diagnostic_modes[current_mode_index]
		vim.diagnostic.config(mode.config)
		utils.printv("LSP Mode: " .. mode.name)
	end

	map_explicit({
		mode = "n",
		sequence = "<leader>dt",
		action = function()
			diagnostics_active = not diagnostics_active
			set_diagnostics_mode()
		end,
		opts = { desc = "Toggle LSP Diagnostics" },
	})
	map_explicit({
		mode = "n",
		sequence = "<leader>dm",
		action = function()
			if not diagnostics_active then
				diagnostics_active = true
				current_mode_index = 1
			else
				current_mode_index = current_mode_index + 1
				if current_mode_index > #diagnostic_modes then
					current_mode_index = 1
				end
			end
			set_diagnostics_mode()
		end,
		desc = "Cycle LSP Diagnostic Modes",
	})

	set_diagnostics_mode()
end

function setups.trouble()
	-- https://github.com/folke/trouble.nvim
	-- A pretty diagnostics, references, telescope results,
	--     quickfix and location list to help you solve all
	--     the trouble your code is causing

	---@class trouble.Mode: trouble.Config,trouble.Section.spec
	---@field desc? string
	---@field sections? string[]

	---@class trouble.Config
	---@field mode? string
	---@field config? fun(opts:trouble.Config)
	---@field formatters? table<string,trouble.Formatter> custom formatters
	---@field filters? table<string, trouble.FilterFn> custom filters
	---@field sorters? table<string, trouble.SorterFn> custom sorters
	local trouble_defaults = {
		auto_close = false, -- auto close when there are no items
		auto_open = false, -- auto open when there are items
		auto_preview = true, -- automatically open preview when on an item
		auto_refresh = true, -- auto refresh when open
		auto_jump = false, -- auto jump to the item when there's only one
		focus = false, -- Focus the window when opened
		restore = true, -- restores the last location in the list when opening
		follow = true, -- Follow the current item
		indent_guides = true, -- show indent guides
		max_items = 200, -- limit number of items that can be displayed per section
		multiline = true, -- render multi-line messages
		pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
		warn_no_results = true, -- show a warning when there are no results
		open_no_results = false, -- open the trouble window when there are no results
		---@type trouble.Window.opts
		win = {}, -- window options for the results window. Can be a split or a floating window.
		-- Window options for the preview window. Can be a split, floating window,
		-- or `main` to show the preview in the main editor window.
		---@type trouble.Window.opts
		preview = {
			type = "main",
			-- when a buffer is not yet loaded, the preview window will be created
			-- in a scratch buffer with only syntax highlighting enabled.
			-- Set to false, if you want the preview to always be a real loaded buffer.
			scratch = true,
		},
		-- Throttle/Debounce settings. Should usually not be changed.
		---@type table<string, number|{ms:number, debounce?:boolean}>
		throttle = {
			refresh = 20, -- fetches new data when needed
			update = 10, -- updates the window
			render = 10, -- renders the window
			follow = 100, -- follows the current item
			preview = { ms = 100, debounce = true }, -- shows the preview for the current item
		},
		-- Key mappings can be set to the name of a builtin action,
		-- or you can define your own custom action.
		---@type table<string, trouble.Action.spec|false>
		keys = {
			["?"] = "help",
			r = "refresh",
			R = "toggle_refresh",
			q = "close",
			o = "jump_close",
			["<esc>"] = "cancel",
			["<cr>"] = "jump",
			["<2-leftmouse>"] = "jump",
			["<c-s>"] = "jump_split",
			["<c-v>"] = "jump_vsplit",
			-- go down to next item (accepts count)
			-- j = "next",
			["}"] = "next",
			["]]"] = "next",
			-- go up to prev item (accepts count)
			-- k = "prev",
			["{"] = "prev",
			["[["] = "prev",
			dd = "delete",
			d = { action = "delete", mode = "v" },
			i = "inspect",
			p = "preview",
			P = "toggle_preview",
			zo = "fold_open",
			zO = "fold_open_recursive",
			zc = "fold_close",
			zC = "fold_close_recursive",
			za = "fold_toggle",
			zA = "fold_toggle_recursive",
			zm = "fold_more",
			zM = "fold_close_all",
			zr = "fold_reduce",
			zR = "fold_open_all",
			zx = "fold_update",
			zX = "fold_update_all",
			zn = "fold_disable",
			zN = "fold_enable",
			zi = "fold_toggle_enable",
			gb = { -- example of a custom action that toggles the active view filter
				action = function(view)
					view:filter({ buf = 0 }, { toggle = true })
				end,
				desc = "Toggle Current Buffer Filter",
			},
			s = { -- example of a custom action that toggles the severity
				action = function(view)
					local f = view:get_filter("severity")
					local severity = ((f and f.filter.severity or 0) + 1) % 5
					view:filter({ severity = severity }, {
						id = "severity",
						template = "{hl:Title}Filter:{hl} {severity}",
						del = severity == 0,
					})
				end,
				desc = "Toggle Severity Filter",
			},
		},
		---@type table<string, trouble.Mode>
		modes = {
			-- sources define their own modes, which you can use directly,
			-- or override like in the example below
			lsp_references = {
				-- some modes are configurable, see the source code for more details
				params = {
					include_declaration = true,
				},
			},
			-- The LSP base mode for:
			-- * lsp_definitions, lsp_references, lsp_implementations
			-- * lsp_type_definitions, lsp_declarations, lsp_command
			lsp_base = {
				params = {
					-- don't include the current location in the results
					include_current = false,
				},
			},
			-- more advanced example that extends the lsp_document_symbols
			symbols = {
				desc = "document symbols",
				mode = "lsp_document_symbols",
				focus = false,
				win = { position = "right" },
				filter = {
					-- remove Package since luals uses it for control flow structures
					["not"] = { ft = "lua", kind = "Package" },
					any = {
						-- all symbol kinds for help / markdown files
						ft = { "help", "markdown" },
						-- default set of symbol kinds
						kind = {
							"Class",
							"Constructor",
							"Enum",
							"Field",
							"Function",
							"Interface",
							"Method",
							"Module",
							"Namespace",
							"Package",
							"Property",
							"Struct",
							"Trait",
						},
					},
				},
			},
		},
		icons = {
			---@type trouble.Indent.symbols
			indent = {
				top = "│ ",
				middle = "├╴",
				last = "└╴",
				-- last          = "-╴",
				-- last       = "╰╴", -- rounded
				fold_open = " ",
				fold_closed = " ",
				ws = "  ",
			},
			folder_closed = " ",
			folder_open = " ",
			kinds = {
				Array = " ",
				Boolean = "󰨙 ",
				Class = " ",
				Constant = "󰏿 ",
				Constructor = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Function = "󰊕 ",
				Interface = " ",
				Key = " ",
				Method = "󰊕 ",
				Module = " ",
				Namespace = "󰦮 ",
				Null = " ",
				Number = "󰎠 ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				String = " ",
				Struct = "󰆼 ",
				TypeParameter = " ",
				Variable = "󰀫 ",
			},
		},
	}
	setup_plugin("trouble.nvim", trouble_defaults)
end

function setups.quicker()
	-- https://github.com/stevearc/quicker.nvim
	-- Improved UI and workflow for the Neovim quickfix

	local quicker_defaults = {
		-- Local options to set for quickfix
		opts = {
			buflisted = false,
			number = false,
			relativenumber = false,
			signcolumn = "auto",
			winfixheight = true,
			wrap = false,
		},
		-- Set to false to disable the default options in `opts`
		use_default_opts = true,
		-- Keymaps to set for the quickfix buffer
		keys = {
			-- { ">", "<cmd>lua require('quicker').expand()<CR>", desc = "Expand quickfix content" },
		},
		-- Callback function to run any custom logic or keymaps for the quickfix buffer
		on_qf = function(bufnr) end,
		edit = {
			-- Enable editing the quickfix like a normal buffer
			enabled = true,
			-- Set to true to write buffers after applying edits.
			-- Set to "unmodified" to only write unmodified buffers.
			autosave = "unmodified",
		},
		-- Keep the cursor to the right of the filename and lnum columns
		constrain_cursor = true,
		highlight = {
			-- Use treesitter highlighting
			treesitter = true,
			-- Use LSP semantic token highlighting
			lsp = true,
			-- Load the referenced buffers to apply more accurate highlights (may be slow)
			load_buffers = false,
		},
		follow = {
			-- When quickfix window is open, scroll to closest item to the cursor
			enabled = false,
		},
		-- Map of quickfix item type to icon
		type_icons = {
			E = "󰅚 ",
			W = "󰀪 ",
			I = " ",
			N = " ",
			H = " ",
		},
		-- Border characters
		borders = {
			vert = "┃",
			-- Strong headers separate results from different files
			strong_header = "━",
			strong_cross = "╋",
			strong_end = "┫",
			-- Soft headers separate results within the same file
			soft_header = "╌",
			soft_cross = "╂",
			soft_end = "┨",
		},
		-- How to trim the leading whitespace from results. Can be 'all', 'common', or false
		trim_leading_whitespace = "common",
		-- Maximum width of the filename column
		max_filename_width = function()
			return math.floor(math.min(95, vim.o.columns / 2))
		end,
		-- How far the header should extend to the right
		header_length = function(type, start_col)
			return vim.o.columns - start_col
		end,
	}
	setup_plugin("quicker", quicker_defaults)
end

function setups.bqf()
	-- https://github.com/kevinhwang91/nvim-bqf
	-- Better quickfix window in Neovim, polish old quickfix window.
	local bqf_config = {
		auto_enable = true,
		auto_resize_height = true, -- highly recommended enable
		preview = {
			win_height = 12,
			win_vheight = 12,
			delay_syntax = 80,
			border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
			show_title = false,
			should_preview_cb = function(bufnr, qwinid)
				local ret = true
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				local fsize = vim.fn.getfsize(bufname)
				if fsize > 100 * 1024 then
					-- skip file size greater than 100k
					ret = false
				elseif bufname:match("^fugitive://") then
					-- skip fugitive buffer
					ret = false
				end
				return ret
			end,
		},
		-- make `drop` and `tab drop` to become preferred
		func_map = {
			drop = "o",
			openc = "O",
			split = "<C-s>",
			tabdrop = "<C-t>",
			-- set to empty string to disable
			tabc = "",
			ptogglemode = "z,",
		},
		filter = {
			fzf = {
				action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
				extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
			},
		},
	}
	setup_plugin("bqf", bqf_config)

	--TODO: fix this
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",

		callback = function()
			print("Entered quickfix!")
		end,

		setup_plugin("nvim-bqf", {}), -- TODO
	})
end

setups["error-jump"] = function() -- TODO: implement for simple in-file navigation to jump to next error
	-- (this plugin is for jumping to an error given a location such as 'file.kl:34:2')
	-- https://github.com/Dr-42/error-jump.nvim
	-- Gives basic functionality for error messages with format filename:line:column
	setup_plugin("error-jump", function(error_jump)
		map_explicit({
			mode = "n",
			sequence = "<leader>es",
			action = error_jump.jump_to_error,
			desc = "[E]rror [S]ource",
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>en",
			action = error_jump.next_error,
			desc = "[E]rror [N]ext",
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>eN",
			action = error_jump.previous_error,
			desc = "[E]rror [N]previous",
		})
		map_explicit({
			mode = "n",
			sequence = "<leader>ec",
			action = error_jump.compile,
			desc = "[E]rror [C]ompile",
		})
	end)
end

-- TODO: not currently working; probably dominated by quicker+bqf
function setups.qfview()
	-- https://github.com/ashfinal/qfview.nvim
	-- Pretty quickfix/location view for Neovim
	-- no config options
	setup_plugin("qfview", {})
end

-- TODO: not currently working
function setups.dmap()
	-- https://github.com/doums/dmap.nvim
	-- nvim plugin providing a subtle overview of LSP diagnostics
	local dmap_defaults = {
		-- highlight groups used for diagnostic marks
		-- by default link to corresponding `DiagnosticSign*` groups
		d_hl = {
			hint = "dmapHint",
			info = "dmapInfo",
			warn = "dmapWarn",
			error = "dmapError",
		},
		-- highlight group used for the diagnostic window
		-- by default link to `NormalFloat`
		win_hl = "dmapWin",
		-- text used for diagnostic marks
		-- ⚠ the text must be one character long
		d_mark = {
			hint = "╸",
			info = "╸",
			warn = "╸",
			error = "╸",
		},
		-- max height of the diagnostic window
		-- if not set defaults to the height of the reference window
		-- must be positive
		win_max_height = nil,
		-- alignment of the diagnostic window relative to the reference window
		-- `left` | `right`
		win_align = "right",
		-- horizontal offset (in character cell) of the diagnostic window
		-- must be positive
		win_h_offset = 1,
		-- vertical offset (in character cell) of the diagnostic window
		-- must be positive
		win_v_offset = 1,
		-- ignore these diagnostic sources
		ignore_sources = {},
		-- ignore these filetypes buffer
		ignore_filetypes = { "NvimTree" },
		-- severity option passed to `vim.diagnostic.get()` (`:h diagnostic-severity`)
		severity = nil,
		-- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
		-- ⚠ can potentially break the plugin, use at your own risk
		nvim_float_api = nil,
	}
	setup_plugin("dmap", dmap_defaults)
end

-- TODO: make play nicely with other diagnostic modes
function setups.corn()
	-- https://github.com/RaafatTurki/corn.nvim
	-- LSP diagnostics at your corner
	local corn_defaults = {
		-- enables plugin auto commands
		auto_cmds = true,

		-- sorts diagnostics according to a criteria. must be one of `severity`, `severity_reverse`, `column`, `column_reverse`, `line_number` or `line_number_reverse`
		sort_method = "severity",

		-- sets the scope to be searched for diagnostics, must be one of `line` or `file`
		scope = "line",

		-- sets the style of the border, must be one of `single`, `double`, `rounded`, `solid`, `shadow` or `none`
		border_style = "none",

		-- sets which vim modes corn isn't allowed to render in, should contain strings like 'n', 'i', 'v', 'V' .. etc
		blacklisted_modes = {},

		-- sets which severity corn isn't allowed to render in, should contain diagnostic severities like:
		-- vim.diagnostic.severity.HINT
		-- vim.diagnostic.severity.INFO
		-- vim.diagnostic.severity.WARN
		-- vim.diagnostic.severity.ERROR
		blacklisted_severities = {},

		-- highlights to use for each diagnostic severity level
		highlights = {
			error = "DiagnosticFloatingError",
			warn = "DiagnosticFloatingWarn",
			info = "DiagnosticFloatingInfo",
			hint = "DiagnosticFloatingHint",
		},

		-- icons to use for each diagnostic severity level
		icons = {
			error = " E",
			warn = " W",
			hint = " H",
			info = " I",
		},

		-- a preprocessor function that takes a raw Corn.Item and returns it after modification, could be used for truncation or other purposes
		item_preprocess_func = function(item)
			-- pad with space
			-- item.message = item.message .. " "
			return item
		end,

		-- a hook that executes each time corn is toggled. the current state is provided via `is_hidden`
		on_toggle = function(is_hidden)
			-- custom logic goes here
		end,
	}
	local corn = setup_plugin("corn", corn_defaults)
	vim.g.corn_enabled = false

	local function toggle_corn()
		vim.g.corn_enabled = not vim.g.corn_enabled

		corn.toggle()
	end

	map_explicit({
		mode = "n",
		sequence = "<leader>dc",
		action = toggle_corn,
		desc = "Toggle corn.nvim (LSP diagnostics in floating popup)",
	})
end

-- TODO: add keybind to inspect or get further info on lightbulb (analogous to clicking in VSCode)
setups["nvim-lightbulb"] = function()
	-- https://github.com/kosayoda/nvim-lightbulb
	-- VSCode 💡 for neovim's built-in LSP.
	local nvim_lightbulb_defaults = {
		-- Priority of the lightbulb for all handlers except float.
		priority = 10,

		-- Whether or not to hide the lightbulb when the buffer is not focused.
		-- Only works if configured during NvimLightbulb.setup
		hide_in_unfocused_buffer = true,

		-- Whether or not to link the highlight groups automatically.
		-- Default highlight group links:
		--   LightBulbSign -> DiagnosticSignInfo
		--   LightBulbFloatWin -> DiagnosticFloatingInfo
		--   LightBulbVirtualText -> DiagnosticVirtualTextInfo
		--   LightBulbNumber -> DiagnosticSignInfo
		--   LightBulbLine -> CursorLine
		-- Only works if configured during NvimLightbulb.setup
		link_highlights = true,

		-- Perform full validation of configuration.
		-- Available options: "auto", "always", "never"
		--   "auto" only performs full validation in NvimLightbulb.setup.
		--   "always" performs full validation in NvimLightbulb.update_lightbulb as well.
		--   "never" disables config validation.
		validate_config = "auto",

		-- Code action kinds to observe.
		-- To match all code actions, set to `nil`.
		-- Otherwise, set to a table of kinds.
		-- Example: { "quickfix", "refactor.rewrite" }
		-- See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeActionKind
		action_kinds = nil,

		-- Enable code lens support.
		-- If the current position has executable code lenses, the icon is changed from `text` to `lens_text`
		-- for sign, virtual_text, float and status_text.
		-- The code lens icon is configurable per handler.
		code_lenses = false,

		-- Configuration for various handlers:
		-- 1. Sign column.
		sign = {
			enabled = true,
			-- Text to show in the sign column.
			-- Must be between 1-2 characters.
			text = "💡",
			lens_text = "🔎",
			-- Highlight group to highlight the sign column text.
			hl = "LightBulbSign",
		},

		-- 2. Virtual text.
		virtual_text = {
			enabled = false,
			-- Text to show in the virt_text.
			text = "💡",
			lens_text = "🔎",
			-- Position of virtual text given to |nvim_buf_set_extmark|.
			-- Can be a number representing a fixed column (see `virt_text_pos`).
			-- Can be a string representing a position (see `virt_text_win_col`).
			pos = "eol",
			-- Highlight group to highlight the virtual text.
			hl = "LightBulbVirtualText",
			-- How to combine other highlights with text highlight.
			-- See `hl_mode` of |nvim_buf_set_extmark|.
			hl_mode = "combine",
		},

		-- 3. Floating window.
		float = {
			enabled = false,
			-- Text to show in the floating window.
			text = "💡",
			lens_text = "🔎",
			-- Highlight group to highlight the floating window.
			hl = "LightBulbFloatWin",
			-- Window options.
			-- See |vim.lsp.util.open_floating_preview| and |nvim_open_win|.
			-- Note that some options may be overridden by |open_floating_preview|.
			win_opts = {
				focusable = false,
			},
		},

		-- 4. Status text.
		-- When enabled, will allow using |NvimLightbulb.get_status_text|
		-- to retrieve the configured text.
		status_text = {
			enabled = false,
			-- Text to set if a lightbulb is available.
			text = "💡",
			lens_text = "🔎",
			-- Text to set if a lightbulb is unavailable.
			text_unavailable = "",
		},

		-- 5. Number column.
		number = {
			enabled = false,
			-- Highlight group to highlight the number column if there is a lightbulb.
			hl = "LightBulbNumber",
		},

		-- 6. Content line.
		line = {
			enabled = false,
			-- Highlight group to highlight the line if there is a lightbulb.
			hl = "LightBulbLine",
		},

		-- Autocmd configuration.
		-- If enabled, automatically defines an autocmd to show the lightbulb.
		-- If disabled, you will have to manually call |NvimLightbulb.update_lightbulb|.
		-- Only works if configured during NvimLightbulb.setup
		autocmd = {
			-- Whether or not to enable autocmd creation.
			enabled = false,
			-- See |updatetime|.
			-- Set to a negative value to avoid setting the updatetime.
			updatetime = 200,
			-- See |nvim_create_autocmd|.
			events = { "CursorHold", "CursorHoldI" },
			-- See |nvim_create_autocmd| and |autocmd-pattern|.
			pattern = { "*" },
		},

		-- Scenarios to not show a lightbulb.
		ignore = {
			-- LSP client names to ignore.
			-- Example: {"null-ls", "lua_ls"}
			clients = {},
			-- Filetypes to ignore.
			-- Example: {"neo-tree", "lua"}
			ft = {},
			-- Ignore code actions without a `kind` like refactor.rewrite, quickfix.
			actions_without_kind = false,
		},

		--- A general filter function for code actions.
		--- The function is called for code actions *after* any `ignore` or `action_kinds`
		--- options are applied.
		--- The function should return true to keep the code action, false otherwise.
		---@type (fun(client_name:string, result:lsp.CodeAction|lsp.Command):boolean)|nil
		filter = nil,
	}
	setup_plugin("nvim-lightbulb")
end

setup_all_enabled("diagnostics", setups)
