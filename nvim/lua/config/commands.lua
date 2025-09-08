-- Custom user commands
-- Define helpful commands for development workflow

---------------------------------------------------------------------------
-- Task management command
---------------------------------------------------------------------------
-- :Task - Set current task name for statusline display
-- Usage: :Task working on feature X
vim.g.CURRENT_TASK_NAME = "No task"
vim.api.nvim_create_user_command("Task", function(args)
	if args["args"] then
		vim.g.CURRENT_TASK_NAME = "🚀 Working on: [ " .. args["args"] .. " ]"
	end
end, { desc = "Update task name", nargs = "*" })

---------------------------------------------------------------------------
-- URL content fetcher (commented out)
---------------------------------------------------------------------------
-- :UrlOpen - Fetch data from URL and open in new buffer
-- Attempts JSON parsing, falls back to plain text
-- Usage: :UrlOpen https://api.example.com/data
--
-- vim.api.nvim_create_user_command(
--   'UrlOpen',
--   function(args)
--     local url = args['args']
--     local handle = io.popen("curl " .. url)
--
--     if handle ~= nil then
--       local result = handle:read("*a")
--       handle:close()
--       -- Insert content into new buffer
--       vim.api.nvim_command("botright vsplit " .. url)
--       vim.api.nvim_input("<Esc>:r !" .. result .. "<CR>")
--     else
--       print("Failed to read..")
--     end
--   end,
--   { desc = "Display the content of a url in buffer", nargs = "*" }
-- )
