-- C:\Users\username\.wezterm.lua (Windows)
-- /home/username/.wezterm.lua (Linux/macOS)
local wezterm = require "wezterm"
local mux = wezterm.mux

local config = wezterm.config_builder()

local is_windows <const> = wezterm.target_triple:find "windows" ~= nil
local is_macos <const> = wezterm.target_triple:find "darwin" ~= nil

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

if is_windows then
  config.default_domain = "WSL:Ubuntu-24.04"
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
    key = "F11",
    mods = "",
    action = wezterm.action.ToggleFullScreen,
  },
}

config.automatically_reload_config = true
config.enable_tab_bar = false
config.adjust_window_size_when_changing_font_size = false

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font "JetBrainsMono Nerd Font Mono"

if is_macos then
  config.font_size = 18.0
else
  config.font_size = 12.0
end

return config
