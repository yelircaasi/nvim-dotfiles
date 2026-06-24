local function check_rg()
	local rg = utils.get_executable("rg")
	if rg == "" then
		-- print("ripgrep (rg) not found on PATH — grep features will not work.")
		vim.notify("ripgrep (rg) not found on PATH — grep features will not work.", vim.log.levels.ERROR)
		return false
	end
	return true
end

-- local function ensure_rg()
--     if vim.fn.executable("rg") == 0 then
--         vim.notify("ripgrep (rg) not found on PATH — grep features will not work.", vim.log.levels.ERROR)
--         return false
--     end
--     return true
-- end

check_rg()

-- map_explicit({
--     sequence = "<leader>fg",
--     action = function()
--         if not ensure_rg() then return end
--         require("telescope.builtin").live_grep()
--     end,
-- })
