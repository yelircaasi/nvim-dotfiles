local M = {}

---@param filetypes {string: boolean}
function M.create(filetypes, features)
	for filetype, included in pairs(filetypes) do
		if included then
			create_ft_autocmd(filetype, function(ev)
				require("langs." .. filetype).setup(ev, features)
			end)
		end
	end
end

return M
