-- Statusline drawn as pills to match the tmux status bar, and a quiet tabline.
-- Normal mode, the current buffer and the position use the tmux session accent,
-- so nvim and tmux share one colour per session. Outside tmux the accent is blue.

local M = {}

local L, R = "\238\130\182", "\238\130\180" -- U+E0B6 and U+E0B4, the round caps in tmux.conf
local BRANCH = "\238\130\160" -- U+E0A0

local c = {
	text = "#cdd6f4",
	overlay0 = "#6c7086",
	overlay1 = "#7f849c",
	surface0 = "#313244",
	surface2 = "#585b70",
	crust = "#11111b",
	blue = "#89b4fa",
	green = "#a6e3a1",
	peach = "#fab387",
	red = "#f38ba8",
	mauve = "#cba6f7",
	yellow = "#f9e2af",
	sky = "#89dceb",
	teal = "#94e2d5",
}

local function tmux_accent()
	if not vim.env.TMUX then
		return nil
	end
	local out = vim.fn.system({ "tmux", "display-message", "-p", "#{@accent}" })
	out = vim.trim(out)
	return vim.v.shell_error == 0 and out:match("^#%x%x%x%x%x%x$") or nil
end

local accent = (tmux_accent() or c.blue):lower()

-- A mode that has the same colour as the session accent would look like normal
-- mode, so it takes a neighbouring colour instead.
local alternates = { [c.green] = c.teal, [c.peach] = c.yellow, [c.red] = "#eba0ac", [c.mauve] = "#f5c2e7" }
local function mode_colour(colour)
	return colour == accent and alternates[colour] or colour
end

-- Mode name and pill colour. Normal mode takes the session accent.
local modes = {
	n = { "normal", accent },
	i = { "insert", mode_colour(c.green) },
	v = { "visual", mode_colour(c.peach) },
	V = { "v-line", mode_colour(c.peach) },
	["\22"] = { "v-block", mode_colour(c.peach) },
	s = { "select", mode_colour(c.peach) },
	S = { "s-line", mode_colour(c.peach) },
	["\19"] = { "s-block", mode_colour(c.peach) },
	R = { "replace", mode_colour(c.red) },
	c = { "command", mode_colour(c.mauve) },
	r = { "prompt", mode_colour(c.mauve) },
	["!"] = { "shell", mode_colour(c.mauve) },
	t = { "terminal", mode_colour(c.green) },
}

local function set_highlights()
	local hl = vim.api.nvim_set_hl
	hl(0, "StatusLine", { fg = c.text, bg = "NONE" })
	hl(0, "StatusLineNC", { fg = c.overlay1, bg = "NONE" })
	hl(0, "TabLineFill", { bg = "NONE" })

	-- Solid pill: dark text on the accent, like the tmux session pill.
	hl(0, "BarAccent", { fg = c.crust, bg = accent, bold = true })
	hl(0, "BarAccentCap", { fg = accent, bg = "NONE" })
	hl(0, "BarAccentSep", { fg = c.surface2, bg = accent })
	-- Soft pill: accent text on surface0, like another tmux session.
	hl(0, "BarSoft", { fg = accent, bg = c.surface0 })
	hl(0, "BarSoftCap", { fg = c.surface0, bg = "NONE" })

	hl(0, "BarTabCurrent", { fg = c.text, bg = "NONE", sp = accent, underline = true })
	hl(0, "BarText", { fg = c.text, bg = "NONE" })
	hl(0, "BarMuted", { fg = c.overlay1, bg = "NONE" })
	hl(0, "BarDot", { fg = c.peach, bg = "NONE" })
	hl(0, "BarAdd", { fg = c.green, bg = "NONE" })
	hl(0, "BarChange", { fg = c.yellow, bg = "NONE" })
	hl(0, "BarDelete", { fg = c.red, bg = "NONE" })
	hl(0, "BarError", { fg = c.red, bg = "NONE" })
	hl(0, "BarWarn", { fg = c.yellow, bg = "NONE" })
	hl(0, "BarInfo", { fg = c.sky, bg = "NONE" })
	hl(0, "BarHint", { fg = c.teal, bg = "NONE" })

	for _, mode in pairs(modes) do
		local name = "BarMode" .. mode[2]:sub(2)
		hl(0, name, { fg = c.crust, bg = mode[2], bold = true })
		hl(0, name .. "Cap", { fg = mode[2], bg = "NONE" })
	end
end

local function esc(s)
	return (s:gsub("%%", "%%%%"))
end

local function pill(group, body)
	return "%#" .. group .. "Cap#" .. L .. "%#" .. group .. "#" .. body .. "%#" .. group .. "Cap#" .. R
end

local function soft_pill(body)
	return "%#BarSoftCap#" .. L .. "%#BarSoft#" .. body .. "%#BarSoftCap#" .. R
end

local function mode_pill()
	local mode = modes[vim.api.nvim_get_mode().mode:sub(1, 1)] or modes.n
	return pill("BarMode" .. mode[2]:sub(2), mode[1])
end

local function file()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "%#BarMuted#[No Name]"
	end
	local path = vim.fn.fnamemodify(name, ":~:.")
	local dir, tail = path:match("^(.*/)([^/]*)$")
	local out = dir and ("%#BarMuted#" .. esc(dir) .. "%#BarText#" .. esc(tail)) or ("%#BarText#" .. esc(path))
	if vim.bo.modified then
		out = out .. " %#BarDot#•"
	end
	if vim.bo.readonly or not vim.bo.modifiable then
		out = out .. " %#BarMuted#ro"
	end
	return out
end

local function diff()
	local d = vim.b.gitsigns_status_dict
	if not d then
		return ""
	end
	local out = {}
	if (d.added or 0) > 0 then
		table.insert(out, "%#BarAdd#+" .. d.added)
	end
	if (d.changed or 0) > 0 then
		table.insert(out, "%#BarChange#~" .. d.changed)
	end
	if (d.removed or 0) > 0 then
		table.insert(out, "%#BarDelete#-" .. d.removed)
	end
	return table.concat(out, " ")
end

local function diagnostics()
	local n = vim.diagnostic.count(0)
	local s = vim.diagnostic.severity
	local out = {}
	for _, item in ipairs({
		{ s.ERROR, "BarError", "E" },
		{ s.WARN, "BarWarn", "W" },
		{ s.INFO, "BarInfo", "I" },
		{ s.HINT, "BarHint", "H" },
	}) do
		if (n[item[1]] or 0) > 0 then
			table.insert(out, "%#" .. item[2] .. "#" .. item[3] .. n[item[1]])
		end
	end
	return table.concat(out, " ")
end

function M.statusline()
	local left = { mode_pill() }
	local branch = vim.b.gitsigns_head
	if branch and branch ~= "" then
		table.insert(left, soft_pill(BRANCH .. " " .. esc(branch)))
	end
	table.insert(left, file())

	local right = {}
	for _, part in ipairs({ diagnostics(), diff() }) do
		if part ~= "" then
			table.insert(right, part)
		end
	end
	if vim.bo.filetype ~= "" then
		table.insert(right, "%#BarMuted#" .. esc(vim.bo.filetype))
	end
	table.insert(right, pill("BarAccent", "%P%#BarAccentSep# › %#BarAccent#%l:%c"))

	return table.concat(left, " ") .. "%#StatusLine#%<%=" .. table.concat(right, "%#StatusLine#  ")
end

-- Buffers on the left, kept quiet so they do not compete with the tmux pills
-- right above: plain names, the current one in normal text with an accent
-- underline. A peach dot marks unsaved changes. Tabs show on the right only
-- when there is more than one, in the same style.
local function tab_item(label, is_current)
	return (is_current and "%#BarTabCurrent#" or "%#BarMuted#") .. label .. "%#TabLineFill#"
end

function M.tabline()
	local current = vim.api.nvim_get_current_buf()
	local parts = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			local name = vim.api.nvim_buf_get_name(buf)
			name = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
			local dot = vim.bo[buf].modified and " %#BarDot#•" or ""
			local click = "%" .. buf .. "@v:lua.require'config.statusline'.click@"
			table.insert(parts, click .. tab_item(esc(name), buf == current) .. dot .. "%X")
		end
	end

	local out = "%#TabLineFill# " .. table.concat(parts, "   ") .. "%<%="
	local tabs = vim.api.nvim_list_tabpages()
	if #tabs > 1 then
		local current_tab = vim.api.nvim_get_current_tabpage()
		for i, tab in ipairs(tabs) do
			out = out .. "%" .. i .. "T" .. tab_item(tostring(i), tab == current_tab) .. " "
		end
		out = out .. "%T"
	end
	return out
end

function M.click(buf)
	if vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_set_current_buf(buf)
	end
end

function M.setup()
	set_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
	vim.api.nvim_create_autocmd({ "ModeChanged", "DiagnosticChanged" }, { command = "redrawstatus" })
	vim.api.nvim_create_autocmd("User", { pattern = "GitSignsUpdate", command = "redrawstatus" })
	vim.o.statusline = "%!v:lua.require'config.statusline'.statusline()"
	vim.o.tabline = "%!v:lua.require'config.statusline'.tabline()"
end

return M
