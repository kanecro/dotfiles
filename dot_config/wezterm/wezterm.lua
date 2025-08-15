-- chezmoiで管理する「本体」wezterm.lua
-- for macOS / Linux / Crostini / WSL

local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- OSを判定するヘルパー関数
local function get_os_type()
  if wezterm.os == "Mac" then
    return "macOS"
  elseif wezterm.os == "Linux" then
    local f = io.open("/proc/version", "r")
    if f then
      local version_info = f:read("*a")
      f:close()
      if version_info:match("[Mm]icrosoft") or version_info:match("[Ww][Ss][Ll]") then
        return "WSL"
      elseif version_info:match("[Cc]hrome[Oo][Ss]") or version_info:match("[Cc]ros") then
        return "Crostini"
      end
    end
    return "Linux"
  else
    return "Other"
  end
end
local os = get_os_type()

-- 共通設定
config.color_scheme = 'Catppuccin Macchiato'
config.window_background_opacity = 0.95
config.window_padding = { left = 12, right = 12, top = 12, bottom = 7 }
config.window_decorations = "TITLE|RESIZE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"
config.scrollback_lines = 5000

-- フォント設定
local font_candidates = {
  'HackGen Console NF', 'UDEV Gothic 35NF', 'JetBrains Mono Nerd Font', 'FiraCode Nerd Font',
}
if os == "macOS" then
  config.font_size = 15.0
  config.font = wezterm.font_with_fallback({ table.unpack(font_candidates), 'Hiragino Maru Gothic ProN', 'Apple Color Emoji' })
else -- Linux, WSL, Crostini
  config.font_size = 13.5
  config.font = wezterm.font_with_fallback({ table.unpack(font_candidates), 'Noto Sans CJK JP', 'Noto Color Emoji' })
end

-- プラットフォーム固有設定
if os == "macOS" then
  config.macos_window_background_blur = 30
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
elseif os == "Crostini" then
  config.front_end = "Software"
end
-- Windowsの起動設定は「起動用ファイル」が担当するため、ここには記述しません。

-- キーバインド
config.keys = {
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  { key = '-', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}
if os == "macOS" then
  local mac_keys = {
    { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
    { key = 'n', mods = 'CMD', action = act.SpawnWindow },
    { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
    { key = 'q', mods = 'CMD', action = act.QuitApplication },
    { key = '{', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = '}', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
    { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
    { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
    { key = '0', mods = 'CMD', action = act.ResetFontSize },
  }
  for _, key_config in ipairs(mac_keys) do
    table.insert(config.keys, key_config)
  end
end

-- 最終的に構築した設定テーブルを返す
return config

