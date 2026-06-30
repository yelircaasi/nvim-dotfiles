local setups = {}

function setups.fsread()
	local function fsread_setup_func()
		vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
		vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
		vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })

		-- :FSRead " Flow state visual range
		-- :FSClear " Clear all flow states
		-- :FSToggle " Toggle flow state
	end
	-- setup_plugin("fsread", fsread_setup_func)
	local fsread = require("vendored.fsread")
	fsread_setup_func()
end

setups["wezterm-run"] = function()
	-- TODO
	-- require("wezterm_send").setup()
	vim.opt.runtimepath:prepend(REPOS_DIR .. "/wezterm-run.nvim")
	local wezrun = require("wezterm-run")
	wezrun.setup()
end

function setups.consilium()
	-- TODO
	vim.opt.runtimepath:prepend(REPOS_DIR .. "/consilium.nvim")
	local consilium = require("consilium")
	consilium.setup()
end

setup_all_enabled("experimental", setups)
