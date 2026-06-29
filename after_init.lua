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

--─────────────────────────────────────────────────────────────────────────────
--──── COLORSCHEME ────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
require("colors")

--─────────────────────────────────────────────────────────────────────────────
--──── CONFIG MODULES ─────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────

local features = {
	["checks"] = true,
	["ui"] = true,
	["treesitter"] = true,
	["lsp"] = true,
	["editing"] = true,
	["navigation"] = true,
	["mappings"] = true,
	["search"] = true,
	["telescope_etc"] = true,

	["ai"] = false,
	["clipboard"] = true,
	["cloud"] = false,
	["completion"] = false,
	["core"] = false, -- empty
	["debugging"] = true,
	["diff"] = false,
	["execution"] = false,
	["experimental"] = true,
	["explorers"] = true,
	["folding"] = true,
	["git"] = false,

	["macros"] = false,
	["miscellaneous"] = false,
	["projects"] = false,
	["replacer"] = false,
	["task_runner"] = false,
	["terminal"] = false,
	["testing"] = true,
	["tmp"] = false,
	["multilang"] = false,
}
languages = {
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
-- not currently necessary
-- vim.g.features = features
-- vim.g.languages = languages

local function maybe_require(mod_name)
	local include = features[mod_name]
	if include then
		require(mod_name)
	end
end

maybe_require("checks")
maybe_require("lsp")
maybe_require("editing")
maybe_require("navigation")
maybe_require("treesitter")
maybe_require("core")
maybe_require("ui")
maybe_require("experimental")
maybe_require("clipboard")
maybe_require("cloud")
maybe_require("execution")
maybe_require("completion")
maybe_require("explorers")
maybe_require("testing")
maybe_require("folding")
maybe_require("search")
maybe_require("telescope_etc") -- depends: treesitter
maybe_require("diff")
maybe_require("terminal")
maybe_require("debugging")
maybe_require("projects")
maybe_require("macros")
maybe_require("task_runner")
maybe_require("replacer")
maybe_require("git")
maybe_require("ai")
maybe_require("mappings")
maybe_require("miscellaneous")
maybe_require("multilang")
maybe_require("tmp")
maybe_require("experimental")

require("language_support").create(languages, features)

--─────────────────────────────────────────────────────────────────────────────
--──── DEBUG INFO ─────────────────────────────────────────────────────────────
--─────────────────────────────────────────────────────────────────────────────
utils.printv("Reached end of after_init.lua.")
