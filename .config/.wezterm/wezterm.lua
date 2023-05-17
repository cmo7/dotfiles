
-- Extra Paths
local path = {
	nvim = 'C:\\Users\\mconcepcion\\Documents\\Apps\\nvim\\bin;'
}


-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.color_scheme = 'Darcula (base16)'
config.font = wezterm.font 'FiraCode Nerd Font'

-- Tab Bar (Using Tmux for that)
config.enable_tab_bar = false
-- Keys

config.window_padding = {
	left = '1cell',
	right = '1cell',
	top = '0.5cell',
	bottom = '0.5cell',
}

config.keys = {
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}

-- and finally, return the configuration to wezterm
return config

