local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder()

local is_windows <const> = wezterm.target_triple:find('windows') ~= nil

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

if is_windows then
    config.default_domain = 'WSL:Ubuntu-24.04'
else
    config.default_domain = "local"
end

config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

config.keys = {
    {
        key = 'F11',
        mods = '',
        action = wezterm.action.ToggleFullScreen,
    },
}

config.automatically_reload_config = true

config.enable_tab_bar = false

config.color_scheme = 'Catppuccin Macchiato'

config.font = wezterm.font('MesloLGL Nerd Font Mono')
config.font_size = 12

return config
