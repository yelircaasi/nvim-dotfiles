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

local selections = { -- used to ensure mutual exclusivity of conflicting plugins
	picker = "snacks",
	top_line = "dropbar", -- dropbar|nougat|minibar|winbar
	bottom_line = "lualine", -- lualine|nougat|cokeline|heirline|galaxyline|staline|windline
	tab_line = "bufferline", -- bufferline|tabby|nougat
}
-- TODO: make utils.map fail if setting a keymap that conflicts with existing (require explicit )
--     -> use SAFE global to modulate behavior
USING = {
	ai = {
		["copilot"] = false,
		["opencode"] = false,
		["avante"] = false,
		["codecompanion"] = false,
		["llm"] = false,
		["vim-ai"] = false,
		["sg"] = false,
	},
	checks = {
		["rg"] = true,
	},
	clipboard = {
		["general_setup"] = true,
		["autocommands"] = true,
		["yanky"] = true,
		["lazyclip"] = true,
		["pasta"] = true,
		["wastebin"] = true,
	},
	cloud = {
		["kubectl"] = false,
		["kpops"] = false,
		["kubels"] = false,
		["vim-helm"] = false,
		["k8vim"] = false,
		["kubernetes"] = false,
	},
	colors = {
		["odenwald-colorscheme"] = true,
		["headlines"] = true,
		["sunglasses"] = true,
		["configure"] = true,
	},
	completion = {
		["friendly-snippets"] = true,
		["ultisnips"] = true,
		["luasnip"] = true,
		["nvim-cmp"] = true,
		["blink-cmp"] = true,
	},
	debugging = {
		["dapui"] = true,
		["dap-virtual-text"] = false, -- false: fix dependency
		["keymaps"] = true,
		["autommands"] = true,
	},
	diff = {
		["diffview"] = true,
	},
	editing = {
		["general-setup"] = true,
		["vim-commentary"] = true,
		["Comment"] = true,
		["todo-comments"] = true,
		["ts_context_commentstring"] = true,
		["savior"] = true,
		["vim-auto-save"] = true,
		["zpragmatic"] = false,
		["multicursors"] = true, --
		["vim-visual-multi"] = true, -- TODO: make lazy with <leader>vm or other
		["illuminate"] = true,
		["splitjoin"] = false, --        TODO: debug
		["spread"] = false, --           TODO: update (using old nvim-treesitter)
		["treesj"] = true,
		["Bullets"] = true,
		["sort"] = true,
		["ax"] = true,
		["vim-caser"] = false,
		["wrapping"] = true,
		["wrapping-paper"] = true,
		["dotdot"] = false, --           TODO: debug
		["vim-abolish"] = true,
		["date-time-inserter"] = true,
		["switch.vim"] = false, --       prefer dial
		["dial"] = false, --             TODO: debug
		["moveline"] = true,
		["sibling-swap"] = true, --
		["move"] = true,
		["wildfire"] = true,
		["vim-sandwich"] = false, --     look at design and maybe copy best parts, but prefer nvim-surround
		["mini.surround"] = true,
		["ultimate-autopair"] = true,
		["blink.pairs"] = true,
		["rainbow-delimiters"] = true,
		["nvim-autopairs"] = true,
		["nvim-surround"] = true,
		["mini.pairs"] = true,
		["better-digraphs"] = false, --  TODO: debug
		["indent-blankline"] = true,
		["indent-tools"] = false, --     TODO: debug
		["tabular"] = true,
		["indentmini"] = true,
		["mini.indentscope"] = true,
		["anydent"] = true,
		["nvim-anydent"] = true,
		["mini.align"] = true,
		["vim-mundo"] = true,
		["edit-list"] = false, --        TODO: fix import error
		["various-textobjs"] = true,
		["miscellaneous-autocommands"] = true,
	},
	execution = {
		["conjure"] = true,
		["sniprun"] = true,
		["live-command"] = true,
		["channelot"] = true,
		["vim-slime"] = true,
		["jaq"] = true,
		["iron"] = true,
		["resin"] = true,
		["officer"] = true,
		["compiler"] = true,
		["jupytext"] = true,
		["quarto"] = true,
		["asyncrun"] = true,
		["xmake"] = false,
	},
	experimental = {
		["fsread"] = false,
		["wezterm-run"] = false,
		["consilium"] = false,
	},
	explorers = {
		["yazi"] = true,
		["oil"] = true,
		["neotree"] = true,
		["nvimtree"] = true,
		["chadtree"] = false,
	},
	folding = {
		["configure_folding"] = true,
		["ufo"] = false, -- TODO: fix async name collision
	},
	git = {
		["octo"] = false,
		["octohub"] = false,
		["worktrees"] = false,
		["forgit"] = false,
		["official-gitlab"] = false,
		["gitlab"] = false,
		["gitsigns"] = false,
		["jj"] = false,
		["jujutsu"] = false,
		["jiejie"] = false,
		["lazygit"] = false,
		["git-conflict"] = false,
		["neogit"] = false,
		["vim-fugitive"] = false,
		["blame"] = false,
	},
	lsp = {
		["general_setup"] = true,
		["create_keymaps"] = true,
		["create_autocommands"] = true,
		["diagflow"] = true,
		["configure_diagnostics_modes"] = true,
		["conform"] = true,
		["lsp-format"] = true,
		["lspkind"] = true,
		["lspsaga"] = true,
		["doc-window"] = false, -- TODO: update to remove dep on nvim-treesitter.ts_utils
		["trouble"] = true,
		["quicker"] = true,
		["bqf"] = true,
		["nvim-lint"] = true,
		["refactoring"] = true,
		["error-jump"] = true,
		["qfview"] = true,
		["vale"] = true,
		["genghis"] = true,
		["precommit"] = true,
		["lint"] = true,
		["corn"] = true,
		["glance"] = true,
		["dmap"] = true,
		["strict"] = false,
		["inlayhint-filler"] = true,
		["hlargs"] = true,
		["lsp_signature"] = true,
		["nvim-lightbulb"] = true,
		["lsp_formatting"] = true,
	},
	macros = {
		["neocomposer"] = true,
		["nvim-macros"] = true,
		["recorder"] = true,
	},
	mappings = {
		["general_keymaps"] = true,
		["keyseer"] = true,
		["homerows"] = true,
		["whichkey-setup"] = true,
		["better-escape"] = true,
		["which-key"] = true,
		["mini-keymap"] = true,
		["hydra"] = true,
		["insx"] = true,
		["keymap-amend"] = true,
		["unimpaired-which-key"] = true,
		["wf"] = false,
		["keytex"] = true,
		["nvim-keymapper"] = true,
		["mini-keymap"] = true,
		["hawtkeys"] = true,
	},
	miscellaneous = {
		["Launch"] = false,
		["minimal-narrow-region"] = false,
		["telemake"] = false,
		["nvim-api-wrappers"] = false,
		["wezterm-nvim"] = false,
		["advanced_new_file"] = false,
		["tracebundler"] = false,
		["present"] = false,
		["wezterm-move"] = false,
		["move-mode"] = false,
		["runtimetable"] = false,
		["structlog"] = false,
		["tealmaker"] = false,
		["cmdTree"] = false,
		["pommodoro-clock"] = false,
		["pomodoro"] = false,
		["timerly"] = false,
		["timew"] = false,
		["nomodoro"] = false,
		["sche"] = false,
		["twig"] = false,
		["dashboard-nvim"] = false,
		["dashboard"] = false,
		["fsplash"] = false,
		["drop"] = false,
		["doing"] = false,
		["vimwiki"] = false,
		["obsidian"] = false,
		["orgmode"] = false,
		["zettelkasten"] = false,
		["flote"] = false,
		["scratch-buffer"] = false,
		["neowell-lua"] = false,
		["quicknote"] = false,
		["nvim-highlight-colors"] = false,
		["text-to-colorscheme"] = false,
		["minty"] = false,
		["color-picker"] = false,
		["baleia"] = false,
		["easycolor"] = false,
		["export-colorscheme"] = false,
		["bamboo"] = false,
		["kreative"] = false,
		["mini.hipatterns"] = false,
		["paint"] = false,
		["carbon-now-nvim"] = false,
		["showkeys"] = false,
		["hypersonic"] = false,
		["regexplainer"] = false,
		["tldr"] = false,
		["nvim-luaref"] = false,
		["auto-pandoc"] = false,
		["nerdy"] = false,
		["cyrillic"] = false,
		["xkbswitch"] = false,
		["http-codes"] = false,
		["live-server"] = false,
		["web-tools"] = false,
		["api-browser"] = false,
		["metrics"] = false,
		["keylab"] = false,
		["nvim-apm"] = false,
		["daily-focus"] = false,
		["interlaced"] = false,
		["nvmm"] = false,
		["feed"] = false,
		["firenvim"] = false,
		["qalc"] = false,
		["flashcards"] = false,
		["nvim-license"] = false,
	},
	multilang = {
		["knap"] = true,
		["nvim-quicktype"] = true,
		["femaco"] = true,
		["otter"] = true,
	},
	navigation = {
		["general_setup"] = true,
		["spear"] = true,
		["smart-splits"] = true,
		["swm"] = true,
		["nvim_winpick"] = false, -- TODO: write nix expression to build rust
		["windows"] = false, -- TODO: fix config error
		["pragma"] = true,
		["windex-nvim"] = true,
		["bafa"] = true,
		["flybuf"] = true,
		["vuffers"] = true,
		["retrospect"] = true,
		["stickybuf"] = true,
		["spaceport-nvim"] = true,
		["beam"] = true,
		["navigator"] = true,
		["vim-wordmotion"] = false, -- TODO: make ft-specific/lazy
		["clever-f"] = true,
		["hop"] = true,
		["mini.jump"] = true,
		["mini.jump2d"] = true,
		["neowords"] = true,
		["leap"] = true,
		["flash"] = true, -- TODO: make lazy with <leader>fl or similar
		["treemonkey"] = true,
		["vim-edgemotion"] = true,
		["whaler"] = true,
		["marks"] = true,
		["harpoon-core"] = true,
		["markit"] = true,
		["arrow"] = true,
		["gx-extended"] = true,
		["urlview"] = true,
		["highlight-current-n"] = true,
		["mini.pick"] = true,
	},
	projects = {
		["auto_session"] = true,
		["persistence"] = true,
		["project"] = true,
		["mini_sessions"] = true,
		["projector"] = true,
		["neoconf"] = true,
	},
	search = {
		["ido"] = true,
		["regex-vars"] = false,
		["inc_rename"] = false,
		["muren"] = false,
		["rip-substitute"] = false,
		["sad"] = false,
		["fzf-lua"] = false,
		["deck"] = false,
		["snacks"] = false, -- selections.picker == "snacks",
		["hlslens"] = false,
		["nvim-hlsearch"] = false,
		["grug-far"] = false,
		["spectre"] = false,
		["pickme"] = selections.picker == "pickme",
		["renamer"] = false,
		["search-replace"] = false,
		["rgflow"] = false,
		["ssr"] = false,
		["substitute"] = false,
		["actions-preview"] = false,
		["spider"] = false,
		["improved-search-nvim"] = false,
		["nvim-rg"] = false,
		["hlsearch-nvim"] = false,
		["nvim-monorepos"] = false,
		["blink"] = false,
		["replacer"] = false,
	},
	task_runner = {
		["overseer"] = false,
		["custom_telescope"] = false,
		["moonicipal"] = false,
	},
	telescope_etc = {
		["telescope"] = true,
	},
	terminal = {
		["create_keymaps"] = true,
		["vim-floaterm"] = true,
		["toggleterm"] = true,
		["neaterm"] = true,
		["termim"] = true,
		["yarepl"] = true,
		["neomux"] = false,
	},
	testing = {
		["neotest"] = true,
		["coverage"] = true,
	},
	treesitter = {
		["general_setup"] = true,
		["check_parsers"] = true,
		["set_global_ts_languages"] = true,
		["configure_filetypes_and_aliases"] = true,
		["configure_folds_and_indentation"] = true,
		["nvim-treesitter-textobjects"] = true,
		["treesitter-context"] = true,
		["wrap_treesitter_start"] = true,
		["change_commands"] = true,
		["create_autocommands"] = true,
	},
	ui = {
		["nvim-web-devicons"] = true,
		["virtcolumn"] = false,
		["virt-column"] = false,
		["smartcolumn"] = false,
		["statuscol"] = false,
		["TreePin"] = false,
		["symbols"] = true,
		["aerial"] = false,
		["navbuddy"] = false,

		["bufferline"] = selections.tab_line == "bufferline",
		["tabby"] = selections.tab_line == "tabby",
		["nougat::tabline"] = selections.tab_line == "nougat",

		["dropbar"] = selections.top_line == "dropbar",
		["nougat::winbar"] = selections.top_line == "nougat",
		["minibar"] = selections.top_line == "minibar",
		["winbar"] = selections.top_line == "winbar",

		["lualine"] = selections.bottom_line == "lualine",
		["nougat::statusline"] = selections.bottom_line == "nougat",
		["cokeline"] = selections.bottom_line == "cokeline",
		["heirline"] = selections.bottom_line == "heirline",
		["galaxyline"] = selections.bottom_line == "galaxyline",
		["staline"] = selections.bottom_line == "staline",
		["windline"] = selections.bottom_line == "windline",

		["navic"] = false,
		["vimade"] = false,
		["zen-mode"] = true,
		["modicator"] = true,
		["modes"] = true,
		["cmdbuf"] = false,
		["mini.cmdline"] = false,
		["menu"] = false,
		["fidget"] = true,
		["notify"] = false,
		["control-panel"] = false,
		["output-panel"] = false,
		["cosmic-ui"] = false,
		["lvim-ui-config"] = false,
		["volt"] = false,
		["noice"] = false,
		["reactive"] = false,
	},
}

function setup_all_enabled(modname, funcset)
	toggles = USING[modname]

	for name, func in pairs(funcset) do
		if toggles[name] then
			func()
		end
	end
end

LANGUAGES = {
	["python"] = true,
	["go"] = false,
	["haskell"] = false,
	["yaml"] = false,
	["json"] = false,
	["lua"] = false,
	["markdown"] = false,
	["nix"] = false,
	["rust"] = false,
	["tex"] = false,
	["typst"] = false,
	["xit"] = false,
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
