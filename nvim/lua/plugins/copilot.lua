-- Official GitHub Copilot plugin with default settings
-- Simple and reliable AI-powered code completion

return {
	---------------------------------------------------------------------------
	-- Official GitHub Copilot
	---------------------------------------------------------------------------
	{
		"github/copilot.vim",
		event = "VimEnter",
		config = function()
			-- Use default settings - no configuration needed
			-- Just run :Copilot setup to authenticate
		end,
	},
}
