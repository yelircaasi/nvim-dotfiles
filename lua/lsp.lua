-- TODO: Divide up by language and keep only the global (cross-language) configuration here.
-- [Modern Neovim LSP Setup Guide](https://www.youtube.com/watch?v=lljs_7xB7Ps)
-- TODOs:
--   setup_plugin("null-ls") -- OBSOLETE
--   setup_plugin("guard") -- TODO - needed?

local setups = {}

function setups.general_setup()
	vim.cmd("set completeopt+=noselect")
end

setups["lsp-format"] = function()
	-- SUPERCHARGED
	setup_plugin("lsp-format", {
		typescript = {
			tab_width = function()
				return vim.opt.shiftwidth:get()
			end,
		},
		yaml = { tab_width = 2 },
	})
end

function setups.lspkind()
	local lspkind_defaults = {
		-- defines how annotations are shown
		-- default: symbol
		-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
		mode = "symbol_text",

		-- default symbol map
		-- can be either 'default' (requires nerd-fonts font) or
		-- 'codicons' for codicon preset (requires vscode-codicons font)
		--
		-- default: 'default'
		preset = "codicons",

		-- override preset symbols
		--
		-- default: {}
		symbol_map = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "",
		},
	}
	setup_plugin("lspkind", function(lspkind)
		lspkind.init(lspkind_defaults)
	end)
end

function setups.lspsaga()
	local lspsaga_defaults = {
		layout = "normal", -- "float"
		symbol_in_winbar = {
			enable = true,
			separator = " › ",
			hide_keyword = false,
			show_file = true,
			folder_level = 1,
			color_mode = true,
			delay = 300,
		},
		code_action = {
			num_shortcut = true,
			show_server_name = false,
			extend_gitsigns = false,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		definition = {
			width = 0.6,
			height = 0.5,
			keys = {
				edit = "o",
				edit = "<C-c>o",
				vsplit = "<C-c>v",
				split = "<C-c>i",
				tabe = "<C-c>t",
				quit = "q",
				close = "<C-c>k",
			},
		},
		diagnostic = {
			show_code_action = true,
			jump_num_shortcut = true,
			max_width = 0.8,
			max_height = 0.6,
			text_hl_follow = true,
			border_follow = true,
			extend_relatedInformation = false,
			show_layout = "float",
			show_normal_height = 10,
			max_show_width = 0.9,
			max_show_height = 0.6,
			diagnostic_only_current = false,
			keys = {
				exec_action = "o",
				quit = "q",
				toggle_or_jump = "<CR>",
				quit_in_show = { "q", "<ESC>" },
			},
		},
		finder = {
			max_height = 0.5,
			left_width = 0.3,
			right_width = 0.3,
			default = "ref+imp",
			methods = {},
			layout = "float",
			filter = {}, -- TODO
			silent = false,
			keys = {
				shuttle = "[w",
				toggle_or_open = "o",
				vsplit = "s",
				split = "i",
				tabe = "t",
				tabnew = "r",
				quit = "q",
				close = "<C-c>k",
			},
		},
		outline = {
			win_position = "right",
			win_width = 30,
			auto_preview = true,
			detail = true,
			auto_close = true,
			close_after_jump = false,
			layout = "normal",
			max_height = 0.5,
			left_width = 0.3,
			keys = {
				toggle_or_jump = "o",
				quit = "q",
				jump = "e",
			},
		},
		rename = {
			in_select = true,
			auto_save = false,
			project_max_width = 0.5,
			project_max_height = 0.5,
			keys = {
				quit = "<C-k>",
				exec = "<CR>",
				select = "x",
			},
		},
		ui = {
			border = "single",
			devicon = true,
			title = true,
			expand = "⊞",
			collapse = "⊟",
			code_action = "💡",
			actionfix = " ",
			lines = { "┗", "┣", "┃", "━", "┏" },
			kind = {},
			imp_sign = "󰳛 ",
		},
	}
	setup_plugin("lspsaga", lspsaga_defaults)
	map_explicit({
		mode = { "n", "t" },
		action = "<A-d>",
		sequence = "<cmd>Lspsaga term_toggle",
	})
	map_explicit({
		mode = "n",
		action = "K",
		sequence = "<cmd>Lspsaga hover_doc",
	})
end

function setups.glance()
	-- https://github.com/dnlhc/glance.nvim
	-- Peek preview window for LSP locations in Neovim
	setup_plugin("glance", function(glance)
		local actions = glance.actions

		local glance_defaults = {
			height = 18, -- Height of the window
			zindex = 45,

			-- When enabled, adds virtual lines behind the preview window to maintain context in the parent window
			-- Requires Neovim >= 0.10.0
			preserve_win_context = true,

			-- Controls whether the preview window is "embedded" within your parent window or floating
			-- above all windows.
			detached = function(winid)
				-- Automatically detach when parent window width < 100 columns
				return vim.api.nvim_win_get_width(winid) < 100
			end,
			-- Or use a fixed setting: detached = true,

			preview_win_opts = { -- Configure preview window options
				cursorline = true,
				number = true,
				wrap = true,
			},

			border = {
				enable = false, -- Show window borders. Only horizontal borders allowed
				top_char = "―",
				bottom_char = "―",
			},

			list = {
				position = "right", -- Position of the list window 'left'|'right'
				width = 0.33, -- Width as percentage (0.1 to 0.5)
			},

			theme = {
				enable = true, -- Generate colors based on current colorscheme
				mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
			},

			mappings = {
				list = {
					["j"] = actions.next, -- Next item
					["k"] = actions.previous, -- Previous item
					["<Down>"] = actions.next,
					["<Up>"] = actions.previous,
					["<Tab>"] = actions.next_location, -- Next location (skips groups, cycles)
					["<S-Tab>"] = actions.previous_location, -- Previous location (skips groups, cycles)
					["<C-u>"] = actions.preview_scroll_win(5), -- Scroll up the preview window
					["<C-d>"] = actions.preview_scroll_win(-5), -- Scroll down the preview window
					["v"] = actions.jump_vsplit, -- Open location in vertical split
					["s"] = actions.jump_split, -- Open location in horizontal split
					["t"] = actions.jump_tab, -- Open in new tab
					["<CR>"] = actions.jump, -- Jump to location
					["o"] = actions.jump,
					["l"] = actions.open_fold,
					["h"] = actions.close_fold,
					["<leader>le"] = actions.enter_win("preview"), -- Focus preview window
					["q"] = actions.close, -- Closes Glance window
					["Q"] = actions.close,
					["<Esc>"] = actions.close,
					["<C-q>"] = actions.quickfix, -- Send all locations to quickfix list
					-- ['<Esc>'] = false -- Disable a mapping
				},

				preview = {
					["Q"] = actions.close,
					["<Tab>"] = actions.next_location, -- Next location (skips groups, cycles)
					["<S-Tab>"] = actions.previous_location, -- Previous location (skips groups, cycles)
					["<leader>le"] = actions.enter_win("list"), -- Focus list window
				},
			},

			hooks = {}, -- Described in Hooks section

			folds = {
				fold_closed = "",
				fold_open = "",
				folded = true, -- Automatically fold list on startup
			},

			indent_lines = {
				enable = true, -- Show indent guidelines
				icon = "│",
			},

			winbar = {
				enable = true, -- Enable winbar for the preview (requires neovim-0.8+)
			},

			use_trouble_qf = false, -- Quickfix action will open trouble.nvim instead of built-in quickfix list
		}

		glance.setup()
	end)
end

setups["inlayhint-filler"] = function()
	-- https://github.com/davidyz/inlayhint-filler.nvim
	-- For some languages like Python, the inlay-hint provided by the language server are actually optional
	--     symbols/tokens that can be inserted into the buffer. This plugin provides an API to insert the
	--     inlay-hint under the cursor into the buffer. In Python, this is useful when you want to insert
	--     the type annotation from the language server into the code, or you want to turn an unnamed
	--     argument (f(10)) into a named argument (f(x=10)).
	--     This is particularly useful when working with functions that takes dozens of arguments.
	local inlayhint_filler_defaults = {
		blacklisted_servers = {}, -- string[]
		force = false,
		eager = false,
		verbose = false,
	}
	setup_plugin("inlayhint-filler", inlayhint_filler_defaults)
end

setups["lsp_signature"] = function()
	-- PROBABLY NOT, BUT WORTH A TRY
	-- https://github.com/ray-x/lsp_signature.nvim
	-- LSP signature hint as you type
	local lsp_signature_defaults = {
		debug = false, -- set to true to enable debug logging
		log_path = vim.fn.stdpath("log") .. "/lsp_signature.log", -- log dir when debug is true
		-- default is  ~/.cache/nvim/lsp_signature.log
		verbose = false, -- show debug line number

		bind = true, -- This is mandatory, otherwise border config won't get registered.
		-- If you want to hook lspsaga or other signature handler, pls set to false
		doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
		-- set to 0 if you DO NOT want any API comments be shown
		-- This setting only take effect in insert mode, it does not affect signature help in normal
		-- mode, 10 by default

		max_height = 12, -- max height of signature floating_window, include borders
		max_width = function()
			return vim.api.nvim_win_get_width(0) * 0.8
		end, -- max_width of signature floating_window, line will be wrapped if exceed max_width
		-- the value need >= 40
		-- if max_width is function, it will be called
		wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
		floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

		floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
		-- will set to true when fully tested, set to false will use whichever side has more space
		-- this setting will be helpful if you do not want the PUM and floating win overlap

		floating_window_off_x = 1, -- adjust float windows x position.
		-- can be either a number or function
		floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
		-- can be either number or function, see examples
		-- ignore_error = func(err, ctx, config), -- this scilence errors, check init.lua for more details

		close_timeout = 4000, -- close floating window after ms when laster parameter is entered
		fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
		hint_enable = true, -- virtual hint enable
		hint_prefix = "🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
		-- or, provide a table with 3 icons
		-- hint_prefix = {
		--     above = "↙ ",  -- when the hint is on the line above the current line
		--     current = "← ",  -- when the hint is on the same line
		--     below = "↖ "  -- when the hint is on the line below the current line
		-- }
		hint_scheme = "String",
		hint_inline = function()
			return false
		end, -- should the hint be inline(nvim 0.10 only)?  default false
		-- return true | 'inline' to show hint inline, return false | 'eol' to show hint at end of line
		-- return one of: true|false|virt_text_pos: 'eol', 'eol_right_align', 'overlay', 'right_align', 'inline'
		hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
		handler_opts = {
			border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
		},

		always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

		auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
		extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
		zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

		padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

		transparency = nil, -- disabled by default, allow floating win transparent value 1~100
		shadow_blend = 36, -- if you using shadow as border use this set the opacity
		shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
		timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
		toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
		toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
		-- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
		-- may not popup when typing depends on floating_window setting

		select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
		move_signature_window_key = nil, -- move the floating window, e.g. {'<M-k>', '<M-j>'} to move up and down, or
		-- table of 4 keymaps, e.g. {'<M-k>', '<M-j>', '<M-h>', '<M-l>'} to move up, down, left, right
		move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating window
		-- e.g. move_cursor_key = '<M-p>',
		-- once moved to floating window, you can use <M-d>, <M-u> to move cursor up and down
		keymaps = {}, -- relate to move_cursor_key; the keymaps inside floating window with arguments of bufnr
		-- e.g. keymaps = function(bufnr) vim.keymap.set(...) end
		-- it can be function that set keymaps
		-- e.g. keymaps = { { 'j', '<C-o>j' }, } this map j to <C-o>j in floating window
		-- <M-d> and <M-u> are default keymaps to move cursor up and down
	}
	setup_plugin("lsp_signature", lsp_signature_defaults)
end

function setups.lsp_formatting() -- TODO: set up for tl
	map_explicit({
		mode = "n",
		sequence = "<leader>lf",
		action = vim.lsp.buf.format,
		desc = "",
	})
end

-- local functions = {
-- 	["general-setup"] = general_setup,
-- 	["create-keymaps"] = create_keymaps,
-- 	["create-autocommands"] = create_autocommands,
-- 	["diagflow"] = setup_diagflow,
-- 	["configure-diagnostics-modes"] = configure_diagnostics_modes,
-- 	["conform"] = setup_conform,
-- 	["lsp-format"] = setup_lsp_format,
-- 	["lspkind"] = setup_lspkind,
-- 	["lspsaga"] = setup_lspsaga,
-- 	["doc-window"] = setup_doc_window,
-- 	["trouble"] = setup_trouble,
-- 	["quicker"] = setup_quicker,
-- 	["bqf"] = setup_bqf,
-- 	["nvim-lint"] = setup_nvim_lint,
-- 	["refactoring"] = setup_refactoring,
-- 	["error-jump"] = setup_error_jump,
-- 	["qfview"] = setup_qfview,
-- 	["vale"] = setup_vale,
-- 	["genghis"] = setup_genghis,
-- 	["precommit"] = setup_precommit,
-- 	["lint"] = setup_lint,
-- 	["corn"] = setup_corn,
-- 	["glance"] = setup_glance,
-- 	["dmap"] = setup_dmap,
-- 	["strict"] = setup_strict,
-- 	["inlayhint-filler"] = setup_inlayhint_filler,
-- 	["hlargs"] = setup_hlargs,
-- 	["lsp_signature"] = setup_lsp_signature,
-- 	["nvim-lightbulb"] = setup_nvim_lightbulb,
-- }
-- local function maybe_call(element_name)
-- 	local include = elements[element_name]
-- 	if include then
-- 		-- print("Calling '" .. element_name .. "'")
-- 		local func = functions[element_name]
-- 		func()
-- 	end
-- end

-- maybe_call("general-setup")
-- maybe_call("create-keymaps")
-- maybe_call("create-autocommands")
-- maybe_call("diagflow")
-- maybe_call("configure-diagnostics-modes")
-- maybe_call("conform")
-- maybe_call("lsp-format")
-- maybe_call("lspkind")
-- maybe_call("lspsaga")
-- maybe_call("doc-window")
-- maybe_call("trouble")
-- maybe_call("quicker")
-- maybe_call("bqf")
-- maybe_call("nvim-lint")
-- maybe_call("refactoring")
-- maybe_call("error-jump")
-- maybe_call("qfview")
-- maybe_call("vale")
-- maybe_call("genghis")
-- maybe_call("precommit")
-- maybe_call("lint")
-- maybe_call("corn")
-- maybe_call("glance")
-- maybe_call("dmap")
-- maybe_call("strict")
-- maybe_call("inlayhint-filler")
-- maybe_call("hlargs")
-- maybe_call("lsp_signature")
-- maybe_call("nvim-lightbulb")

setup_all_enabled("lsp", setups)
