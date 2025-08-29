-- Bootstrap Neovim configuration
-- Load core configuration modules in order

require("config.settings")   -- Core vim options and behavior
require("config.mappings")   -- Key bindings and shortcuts
require("config.commands")   -- Custom user commands
require("config.lazy")       -- Plugin manager and plugin loading
