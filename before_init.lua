-- print("This ran before.")
-- print()
-- print(vim.inspect(vim.opt.runtimepath))
-- print(vim.inspect(vim.opt.packpath))

-- print(vim.o.runtimepath:find(vim.env.VIMRUNTIME) ~= nil)
-- -- vim.o.runtimepath:prepend(vim.env.VIMRUNTIME)
-- print(vim.o.runtimepath:find(vim.env.VIMRUNTIME) ~= nil)

-- print(vim.env.VIMRUNTIME)
-- vim.opt.runtimepath:prepend(vim.env.VIMRUNTIME)
-- print(vim.o.runtimepath:find(vim.env.VIMRUNTIME, 1, true) ~= nil)

-- print(vim.inspect(vim.opt.runtimepath))
-- print(vim.inspect(vim.opt.packpath))

VERBOSE = false
SAFE = true
LAYERS = nil

-- used to ensure mutual exclusivity of conflicting plugins
local selections = {
	picker =      "snacks",
	top_line =    "dropbar", -- dropbar|nougat|minibar|winbar
	bottom_line = "lualine", -- lualine|nougat|cokeline|heirline|galaxyline|staline|windline
	tab_line =    "bufferline", -- bufferline|tabby|nougat
}
-- TODO: make utils.map fail if setting a keymap that conflicts with existing (require explicit )
--     -> use SAFE global to modulate behavior
USING = {
	ai = {
		["copilot"] =               false,
		["opencode"] =               true,
		["avante"] =                false,
		["codecompanion"] =         false,
		["llm"] =                   false,
		["vim-ai"] =                false,
		["sg"] =                    false,
	},
	checks = {
		["rg"] = true,
		["opencode"] =               true,
		["pgrep"] =                  true,
		["curl"] =                   true,
		["lsof"] =                   true,
		["ruff"] =                   true,
		["mypy"] =                   true,
		["git"] =                    true,
		["jj"] =                     true,
		["nil"] =                    true,
		["nixd"] =                   true,
		["rust-analyzer"] =          true,
		["lua-language-server"] =    true,
	},
	clipboard = {
		["general_setup"] =          true,
		["autocommands"] =           true,
		["yanky"] =                 false,
		["lazyclip"] =              false,
		["pasta"] =                 false,
		["wastebin"] =              false,
	},
	cloud = {
		["kubectl"] =               false,
		["kpops"] =                 false,
		["kubels"] =                false,
		["vim-helm"] =              false,
		["k8vim"] =                 false,
		["kubernetes"] =            false,
	},
	colors = {
		["odenwald-colorscheme"] =   true,
		["headlines"] =              true,
		["sunglasses"] =            false,
		["configure"] =              true,
	},
	completion = {
		["friendly-snippets"] =      true,
		["ultisnips"] =             false,
		["luasnip"] =                true,
		["nvim-cmp"] =              false,
		["blink-cmp"] =             false, -- recently true
	},
	debugging = {  -- TODO: next
		["dapui"] =                  true,
		["dap-virtual-text"] =      false, -- TODO: fix dependency
		["keymaps"] =                true,
		["autommands"] =             true,
	},
	diagnostics = {
		["create_keymaps"] =         true,
		["create_autocommands"] =    true,
		["diagflow"] =              false,
		["configure_diagnostics_modes"] = true,
		["trouble"] =                true,
		["quicker"] =                true,
		["bqf"] =                    true,
		["error-jump"] =             true,
		["qfview"] =                 true,
		["dmap"] =                   true,
		["corn"] =                   true,
		["nvim-lightbulb"] =         true,
	},
	diff = {
		["diffview"] =               true,
	},
	editing = {
		["general-setup"] =          true,
		["vim-commentary"] =        false,
		["Comment"] =               false,
		["todo-comments"] =         false,
		["ts_context_commentstring"] = false,
		["savior"] =                false,
		["vim-auto-save"] =         false,
		["zpragmatic"] =            false,
		["multicursors"] =          false, --
		["vim-visual-multi"] =      false, -- TODO: make lazy with <leader>vm or other
		["illuminate"] =            false,
		["splitjoin"] =             false, -- TODO: debug
		["spread"] =                false, -- TODO: update (using old nvim-treesitter)
		["treesj"] =                false,
		["Bullets"] =               false,
		["sort"] =                  false,
		["ax"] =                    false,
		["vim-caser"] =             false,
		["wrapping"] =              false,
		["wrapping-paper"] =        false,
		["dotdot"] =                false, -- TODO: debug
		["vim-abolish"] =           false,
		["date-time-inserter"] =    false,
		["switch.vim"] =            false, -- prefer dial
		["dial"] =                   true,
		["moveline"] =              false,
		["sibling-swap"] =          false, --
		["move"] =                  false,
		["wildfire"] =              false,
		["vim-sandwich"] =          false, -- look at design and maybe copy best parts, but prefer nvim-surround
		["mini.surround"] =         false,
		["ultimate-autopair"] =     false,
		["blink.pairs"] =           false,
		["rainbow-delimiters"] =    false,
		["nvim-autopairs"] =        false,
		["nvim-surround"] =         false,
		["mini.pairs"] =            false,
		["map_ctrl_o"] =            false,
		["better-digraphs"] =       false, -- TODO: debug
		["indent-blankline"] =       true,
		["indent-tools"] =          false, -- TODO: debug
		["tabular"] =               false,
		["indentmini"] =            false,
		["mini.indentscope"] =      false,
		["anydent"] =               false,
		["nvim-anydent"] =          false,
		["mini.align"] =            false,
		["vim-mundo"] =             false,
		["edit-list"] =             false, --        TODO: fix import error
		["various-textobjs"] =      false,
		["miscellaneous-autocommands"] = true,
	},
	execution = {
		["conjure"] =               false,
		["sniprun"] =               false,
		["live-command"] =          false,
		["channelot"] =             false,
		["vim-slime"] =             false,
		["jaq"] =                   false,
		["iron"] =                  false,
		["resin"] =                 false,
		["officer"] =               false,
		["compiler"] =              false,
		["jupytext"] =              false,
		["quarto"] =                false,
		["asyncrun"] =              false,
		["xmake"] =                 false,
	},
	experimental = {
		["fsread"] =                false,
		["wezterm-run"] =           false,
		["consilium"] =             false,
	},
	explorers = {
		["yazi"] =                   true,
		["oil"] =                   false, -- recently true
		["neotree"] =               false, --  recently true
		["nvimtree"] =              false, -- recently true
		["chadtree"] =              false,
		["genghis"] =               false, --  recently true
	},
	folding = {
		["configure_folding"] =     true,
		["ufo"] =                   true, -- TODO: fix async name collision
	},
	git = {
		["octo"] =                  false,
		["octohub"] =               false,
		["worktrees"] =             false,
		["forgit"] =                false,
		["official-gitlab"] =       false,
		["gitlab"] =                false,
		["gitsigns"] =              false,
		["jj"] =                    false,
		["jujutsu"] =               false,
		["jiejie"] =                false,
		["lazygit"] =               false,
		["git-conflict"] =          false,
		["neogit"] =                false,
		["vim-fugitive"] =          false,
		["blame"] =                 false,
	},
	lsp = {
		["general_setup"] =          true,
		["lsp-format"] =             true,
		["lspkind"] =                true,
		["lspsaga"] =                true,
		["glance"] =                 true,
		["inlayhint-filler"] =       true,
		["lsp_signature"] =          true,
		["lsp_formatting"] =         true,
	},
	lsp_like = {
		["doc-window"] =            false, -- TODO: update to remove dep on nvim-treesitter.ts_utils
		["refactoring"] =           false, -- recently true
		["lint"] =                  false, -- recently true
		["hlargs"] =                false, -- recently true
	},
	macros = {
		["neocomposer"] =           false, -- recently true
		["nvim-macros"] =           false, -- recently true
		["recorder"] =              false, -- recently true
	},
	mappings = {
		["general_keymaps"] =        true,
		["keyseer"] =               false, -- recently true
		["homerows"] =              false, -- recently true
		["whichkey-setup"] =        false, -- recently true
		["better-escape"] =         false, -- recently true
		["which-key"] =              true, -- recently true
		["mini-keymap"] =           false, -- recently true
		["hydra"] =                 false, -- recently true
		["insx"] =                  false, -- recently true
		["keymap-amend"] =          false, -- recently true
		["unimpaired-which-key"] =  false, -- recently true
		["wf"] =                    false,
		["keytex"] =                false, -- recently true
		["nvim-keymapper"] =        false, -- recently true
		["mini-keymap"] =           false, -- recently true
		["hawtkeys"] =              false, -- recently true
	},
	miscellaneous = {
		["Launch"] =                false,
		["minimal-narrow-region"] = false,
		["telemake"] =              false,
		["nvim-api-wrappers"] =     false,
		["wezterm-nvim"] =          false,
		["advanced_new_file"] =     false,
		["tracebundler"] =          false,
		["present"] =               false,
		["wezterm-move"] =          false,
		["move-mode"] =             false,
		["runtimetable"] =          false,
		["structlog"] =             false,
		["tealmaker"] =             false,
		["cmdTree"] =               false,
		["pommodoro-clock"] =       false,
		["pomodoro"] =              false,
		["timerly"] =               false,
		["timew"] =                 false,
		["nomodoro"] =              false,
		["sche"] =                  false,
		["twig"] =                  false,
		["dashboard-nvim"] =        false,
		["dashboard"] =             false,
		["fsplash"] =               false,
		["drop"] =                  false,
		["doing"] =                 false,
		["vimwiki"] =               false,
		["obsidian"] =              false,
		["orgmode"] =               false,
		["zettelkasten"] =          false,
		["flote"] =                 false,
		["scratch-buffer"] =        false,
		["neowell-lua"] =           false,
		["quicknote"] =             false,
		["nvim-highlight-colors"] = false,
		["text-to-colorscheme"] =   false,
		["minty"] =                 false,
		["color-picker"] =          false,
		["baleia"] =                false,
		["easycolor"] =             false,
		["export-colorscheme"] =    false,
		["bamboo"] =                false,
		["kreative"] =              false,
		["mini.hipatterns"] =       false,
		["paint"] =                 false,
		["carbon-now-nvim"] =       false,
		["showkeys"] =              false,
		["hypersonic"] =            false,
		["regexplainer"] =          false,
		["tldr"] =                  false,
		["nvim-luaref"] =           false,
		["auto-pandoc"] =           false,
		["nerdy"] =                 false,
		["cyrillic"] =              false,
		["xkbswitch"] =             false,
		["http-codes"] =            false,
		["live-server"] =           false,
		["web-tools"] =             false,
		["api-browser"] =           false,
		["metrics"] =               false,
		["keylab"] =                false,
		["nvim-apm"] =              false,
		["daily-focus"] =           false,
		["interlaced"] =            false,
		["nvmm"] =                  false,
		["feed"] =                  false,
		["firenvim"] =              false,
		["qalc"] =                  false,
		["flashcards"] =            false,
		["nvim-license"] =          false,
	},
	multilang = {
		["knap"] =                  false, -- recently true
		["nvim-quicktype"] =        false, -- recently true
		["femaco"] =                false, -- recently true
		["otter"] =                 false, -- recently true
	},
	navigation = {
		["general_setup"] =         false, -- recently true
		["spear"] =                 false, -- recently true
		["smart-splits"] =          false, -- recently true
		["swm"] =                   false, -- recently true
		["nvim_winpick"] =          false, -- TODO: write nix expression to build rust
		["windows"] =               false, -- TODO: fix config error
		["pragma"] =                false, -- recently true
		["windex-nvim"] =           false, -- recently true
		["bafa"] =                  false, -- recently true
		["flybuf"] =                false, -- recently true
		["vuffers"] =               false, -- recently true
		["retrospect"] =            false, -- recently true
		["stickybuf"] =             false, -- recently true
		["spaceport-nvim"] =        false, -- recently true
		["beam"] =                  false, -- recently true
		["navigator"] =             false, -- recently true
		["vim-wordmotion"] =        false, -- TODO: make ft-specific/lazy
		["clever-f"] =              false, -- recently true
		["hop"] =                   false, -- recently true
		["mini.jump"] =             false, -- recently true
		["mini.jump2d"] =           false, -- recently true
		["neowords"] =              false, -- recently true
		["leap"] =                  false, -- recently true
		["flash"] =                 false, -- recently true -- TODO: make lazy with <leader>fl or similar
		["treemonkey"] =            false, -- recently true
		["vim-edgemotion"] =        false, -- recently true
		["whaler"] =                false, -- recently true
		["marks"] =                 false, -- recently true
		["harpoon-core"] =          false, -- recently true
		["markit"] =                false, -- recently true
		["arrow"] =                 false, -- recently true
		["gx-extended"] =           false, -- recently true
		["urlview"] =               false, -- recently true
		["highlight-current-n"] =   false, -- recently true
		["mini.pick"] =             false, -- recently true
	},
	projects = {
		["auto_session"] =          false, -- recently true
		["persistence"] =           false, -- recently true
		["project"] =               false, -- recently true
		["mini_sessions"] =         false, -- recently true
		["projector"] =             false, -- recently true
		["neoconf"] =               false, -- recently true
	},
	qa = {
		["precommit"] =             false, -- recently true
		["conform"] =                true,
		["strict"] =                false,
	},
	search = {
		["ido"] =                   false, -- recently true
		["regex-vars"] =            false,
		["inc_rename"] =            false,
		["muren"] = false,
		["rip-substitute"] =        false,
		["sad"] =                   false,
		["fzf-lua"] =               false,
		["deck"] =                  false,
		["snacks"] =                false, -- selections.picker == "snacks",
		["hlslens"] =               false,
		["nvim-hlsearch"] =         false,
		["grug-far"] =              false,
		["spectre"] =               false,
		["pickme"] =                selections.picker == "pickme",
		["renamer"] =               false,
		["search-replace"] =        false,
		["rgflow"] =                false,
		["ssr"] =                   false,
		["substitute"] =            false,
		["actions-preview"] =       false,
		["spider"] =                false,
		["improved-search-nvim"] =  false,
		["nvim-rg"] =               false,
		["hlsearch-nvim"] =         false,
		["nvim-monorepos"] =        false,
		["blink"] =                 false,
		["replacer"] =              false,
	},
	task_runner = {
		["overseer"] =              false,
		["custom_telescope"] =      false,
		["moonicipal"] =            false,
	},
	telescope_etc = {
		["telescope"] =              true,
	},
	terminal = {
		["create_keymaps"] =         true,
		["vim-floaterm"] =          false, -- recently true
		["toggleterm"] =            false, -- recently true
		["neaterm"] =               false, -- recently true
		["termim"] =                false, -- recently true
		["yarepl"] =                false, -- recently true
		["neomux"] =                false,
	},
	testing = {
		["neotest"] = true,
		["coverage"] = true,
	},
	treesitter = {
		["general_setup"] =                   true,
		["check_parsers"] =                   true,
		["set_global_ts_languages"] =         true,
		["configure_filetypes_and_aliases"] = true,
		["configure_folds_and_indentation"] = true,
		["nvim-treesitter-textobjects"] =     true,
		["treesitter-context"] =              true,
		["wrap_treesitter_start"] =           true,
		["change_commands"] =                 true,
		["create_autocommands"] =             true,
	},
	ui = {
		["nvim-web-devicons"] =      true, -- recently true
		["virtcolumn"] =            false,
		["virt-column"] =           false,
		["smartcolumn"] =           false,
		["statuscol"] =             false,
		["TreePin"] =               false,
		["symbols"] =               false, --   recently true
		["aerial"] =                false,
		["navbuddy"] =              false,

		["bufferline"] =      selections.tab_line == "bufferline",
		["tabby"] =           selections.tab_line == "tabby",
		["nougat::tabline"] = selections.tab_line == "nougat",

		["dropbar"] =         selections.top_line == "dropbar",
		["nougat::winbar"] =  selections.top_line == "nougat",
		["minibar"] =         selections.top_line == "minibar",
		["winbar"] =          selections.top_line == "winbar",

		["lualine"] =            selections.bottom_line == "lualine",
		["nougat::statusline"] = selections.bottom_line == "nougat",
		["cokeline"] =           selections.bottom_line == "cokeline",
		["heirline"] =           selections.bottom_line == "heirline",
		["galaxyline"] =         selections.bottom_line == "galaxyline",
		["staline"] =            selections.bottom_line == "staline",
		["windline"] =           selections.bottom_line == "windline",

		["navic"] =                 false,
		["vimade"] =                false,
		["zen-mode"] =               true,
		["modicator"] =             false, -- recently true
		["modes"] =                 false, -- recently true
		["cmdbuf"] =                false,
		["mini.cmdline"] =          false,
		["menu"] =                  false,
		["fidget"] =                false, -- recently true
		["notify"] =                false,
		["control-panel"] =         false,
		["output-panel"] =          false,
		["cosmic-ui"] =             false,
		["lvim-ui-config"] =        false,
		["volt"] =                  false,
		["noice"] =                 false,
		["reactive"] =              false,
	},
}

function setup_all_enabled(modname, funcset)
	toggles = USING[modname]

	for name, func in pairs(funcset) do
		if toggles[name] then
			-- print("Setting up " .. name)
			func()
		end
	end
end

LANGUAGES = {
	["python"] =                     true,
	["go"] =                        false,
	["haskell"] =                   false,
	["yaml"] =                      false,
	["json"] =                      false,
	["lua"] =                        true,
	["markdown"] =                  false,
	["nix"] =                        true,
	["prose"] =                     false,
	["rust"] =                      false,
	["tex"] =                       false,
	["typst"] =                     false,
	["xit"] =                       false,
}

LANGUAGE_FEATURES = {
	lsp = true,
	testing = true,
	debugging = true,
	autoformat = true,
}

-- not currently necessary
-- vim.g.pde_features = features
-- vim.g.pde_languages = languages
