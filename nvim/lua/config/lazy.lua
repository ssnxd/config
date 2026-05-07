-- Lazy.nvim plugin manager setup
-- Bootstrap and configure the plugin manager

---------------------------------------------------------------------------
-- Bootstrap lazy.nvim
---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

---------------------------------------------------------------------------
-- Setup plugin manager
---------------------------------------------------------------------------
require("lazy").setup("plugins", {
	-- defaults = { lazy = true }, -- Disabled to ensure plugins load correctly
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		border = "rounded",
	},
	change_detection = {
		notify = false, -- Disable change detection notification
	},
})
