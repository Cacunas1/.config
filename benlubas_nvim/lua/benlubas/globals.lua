-- prints and returns the thing as a string
P = function(...)
	for _, v in ipairs({ ... }) do
		print(vim.inspect(v))
	end
	return ...
end

-- reloads the given modules.
R = function(...)
	return require("plenary.reload").reload_module(...)
end

Border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" }

vim.g.color_theme_name = vim.env["COLOR_THEME"] or "moonfly"

IsLinux = function()
	return jit.os == "Linux"
end

MarkdownMode = function()
	return vim.g.started_by_firenvim or vim.env["MD_MODE"] == "1"
end

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	---@diagnostic disable-next-line: param-type-mismatch
	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

-- Neovide specific setup
if vim.g.neovide then
	vim.o.guifont = "Fira Code:h10" -- text below applies for VimScript
	vim.g.neovide_transparency = 0.8
	vim.g.neovide_normal_opacity = 0.8
end

local opt = vim.opt
-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10
