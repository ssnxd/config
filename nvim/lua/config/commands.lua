-- :Task
-- Set up as task name 
vim.g.CURRENT_TASK_NAME = 'No task' 

vim.api.nvim_create_user_command(
  'Task', 
  function(opts)
    local label = 'Task name: '
    local task_name = vim.fn.input(label)

    vim.g.CURRENT_TASK_NAME = '🚀 Working on: [ ' .. task_name .. ' ]'

  end,
  { nargs = 0 }
)

