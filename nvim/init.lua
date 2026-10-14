-- Bootstrap Neovim configuration
-- Load core configuration modules in order

require("config.settings") -- Core vim options and behavior
require("config.mappings") -- Key bindings and shortcuts
require("config.lazy") -- Plugin manager and plugin loading
require("config.statusline").setup() -- Statusline and tabline, matching tmux
