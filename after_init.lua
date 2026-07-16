utils.printv("Entering after_init.lua.")

--─────────────────────────────────────────────────────────────────────────────
--──── OPTIONS ────────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
require("options")

--─────────────────────────────────────────────────────────────────────────────
--──── GLOBALS ────────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
map_explicit = utils.map
setup_plugin = utils.setup_plugin
packadd = utils.packadd
REPOS_DIR = vim.fn.resolve("~/repos")

--─────────────────────────────────────────────────────────────────────────────
--──── DEPENDENCY MODULES ─────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
-- require("commons.fio")
-- require("nio")
-- require("nui.input")
-- require("jsregexp")
-- require("pathlib")

--─────────────────────────────────────────────────────────────────────────────
--──── TODO: move to utils ────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
function create_ft_autocmd(pattern, callback)
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("ft_" .. pattern, { clear = true }),
		pattern = pattern,
		callback = callback,
	})
end
--[[ tl
function create_ft_autocmd(pattern: string, callback: (function() nil)
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("ft_" .. pattern, { clear = true }),
		pattern = pattern,
		callback = callback,
	})
end
-- ]]

--─────────────────────────────────────────────────────────────────────────────
--──── COLORSCHEME ────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
require("colors")

--─────────────────────────────────────────────────────────────────────────────
--──── CONFIG MODULES ─────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

require("checks")
require("lsp")
require("lsp_like")
require("qa")
require("diagnostics")
require("editing")
require("navigation")
require("treesitter")
require("ui")
require("experimental")
require("clipboard")
require("cloud")
require("execution")
require("completion")
require("explorers")
require("folding")
require("search")
require("telescope_etc") -- depends: treesitter
require("diff")
require("terminal")
require("debugging")
require("projects")
require("macros")
require("task_runner")
require("git")
require("ai")
require("mappings")
require("miscellaneous")
require("multilang")
require("experimental")

require("language_support").create(LANGUAGES, LANGUAGE_FEATURES)

--─────────────────────────────────────────────────────────────────────────────
--──── DEBUG INFO ─────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
utils.printv("Reached end of after_init.lua.")
