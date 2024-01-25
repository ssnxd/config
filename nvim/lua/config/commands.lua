-- :Task
-- Set up as task name
-- @Usage :Task task_name
vim.g.CURRENT_TASK_NAME = 'No task'
vim.api.nvim_create_user_command(
  'Task',
  function(args)
    if (args['args']) then
      vim.g.CURRENT_TASK_NAME = '🚀 Working on: [ ' .. args['args'] .. ' ]'
    end
  end,
  { desc = "Update task name", nargs = "*" }
)

-- :UrlOpen
-- Fetch data from url and open in new buffer
-- first check if can parse to json else will fallback to text
-- @Usage :UrlOpen url
-- vim.api.nvim_create_user_command(
--   'UrlOpen',
--   function(args)
--     local url = args['args']
--     local handle = io.popen("curl " .. url) -- getting our content using curl
-- 
--     if handle ~= nil then
--       local result = handle:read("*a")
--       handle:close()
--       -- Insert "Hello World" into the new buffer
--       vim.api.nvim_command("botright vsplit " .. url)
--       vim.api.nvim_input("<Esc>:r !" .. result .. "<CR>")
--     else
--       print("Failed to read..")
--     end
--   end,
--   { desc = "Display the content of a url in buffer", nargs = "*" }
-- )
