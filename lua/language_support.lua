local M = {}

vim.filetype.add({
	extension = {
		nix = "nix",
		tl = "teal",
		just = "just",
	},
})

---@param filetypes {string: boolean}
function M.create(filetypes, features)
	for filetype, included in pairs(filetypes) do
		if included then
			print(filetype)
			create_ft_autocmd(filetype, function(ev)
				print("autocmd fired for: " .. ev.file)
				require("langs." .. filetype).setup(ev, features)
			end)
		end
	end
end

return M
