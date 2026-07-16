local checks = {}

local function make_exec_checker(exec_name)
	local inner = function()
		local ex = utils.get_executable(exec_name)
		-- print(ex)
		if ex == "" then
			local msg = "`" .. exec_name .. "` not found on PATH; dependent features will not work."
			vim.notify(msg, vim.log.levels.WARN)
			-- print(msg)
			return false
		end
		return true
	end
	return inner
end

local executables = {
	"rg",
	"opencode",
	"pgrep",
	"curl",
	"lsof",
	"git",
	"jj",
	"rust-analyzer",
	"ruff",
	"mypy",
	"lua-language-server",
	"nil",
	"nixd",
}
for _, executable in ipairs(executables) do
	checks[executable] = make_exec_checker(executable)
end
-- function()
-- 	local rg = utils.get_executable("rg")
-- 	if rg == "" then
-- 		-- print("ripgrep (rg) not found on PATH — grep features will not work.")
-- 		vim.notify("ripgrep (rg) not found on PATH — grep features will not work.", vim.log.levels.ERROR)
-- 		return false
-- 	end
-- 	return true
-- end

-- local function ensure_rg()
--     if vim.fn.executable("rg") == 0 then
--         vim.notify("ripgrep (rg) not found on PATH — grep features will not work.", vim.log.levels.ERROR)
--         return false
--     end
--     return true
-- end

-- map_explicit({
--     sequence = "<leader>fg",
--     action = function()
--         if not ensure_rg() then return end
--         require("telescope.builtin").live_grep()
--     end,
-- })

-- TODO next: opencode server, cloud env (k9s, kubectl, minikube, gcp, azure, azd, etc)

setup_all_enabled("checks", checks)

-- TODO
local function SCRATCH_HERE()
	local function check_plugin_health(plugin_name)
		local ok, health = pcall(require, plugin_name .. ".health")
		if not ok then
			-- try alternate convention
			ok, health = pcall(require, "health." .. plugin_name)
		end
		if not ok or type(health.check) ~= "function" then
			return nil, "no health module found for " .. plugin_name
		end

		-- capture the health report output
		local results = {}
		local saved = {
			start = vim.health.start,
			ok = vim.health.ok,
			warn = vim.health.warn,
			error = vim.health.error,
			info = vim.health.info,
		}

		-- temporarily override health reporters to capture output
		vim.health.start = function(msg)
			table.insert(results, { level = "start", msg = msg })
		end
		vim.health.ok = function(msg)
			table.insert(results, { level = "ok", msg = msg })
		end
		vim.health.warn = function(msg)
			table.insert(results, { level = "warn", msg = msg })
		end
		vim.health.error = function(msg)
			table.insert(results, { level = "error", msg = msg })
		end
		vim.health.info = function(msg)
			table.insert(results, { level = "info", msg = msg })
		end

		pcall(health.check)

		-- restore
		for k, v in pairs(saved) do
			vim.health[k] = v
		end

		return results
	end

	local function summarize_health(plugins)
		for _, name in ipairs(plugins) do
			local results, err = check_plugin_health(name)
			if not results then
				vim.notify("SKIP " .. name .. ": " .. err, vim.log.levels.WARN)
			else
				local has_error = vim.tbl_contains(
					vim.tbl_map(function(r)
						return r.level
					end, results),
					"error"
				)
				local has_warn = vim.tbl_contains(
					vim.tbl_map(function(r)
						return r.level
					end, results),
					"warn"
				)
				local level = has_error and vim.log.levels.ERROR
					or has_warn and vim.log.levels.WARN
					or vim.log.levels.INFO
				local icon = has_error and "❌" or has_warn and "⚠️" or "✅"
				vim.notify(icon .. " " .. name, level)
			end
		end
	end

	-- Usage:
	summarize_health({
		"telescope",
		"luasnip",
		"lspconfig",
		"treesitter",
		"mason",
	})
end
