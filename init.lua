-- nvim-simple: Modern Neovim configuration in pure Lua
-- Entry point that loads all modules

-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Bootstrap and load plugins (lazy.nvim)
require("plugins")
