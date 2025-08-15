-- chezmoiで管理する「本体」wezterm.lua
-- for macOS / Linux / Chromebook / WSL


local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

wezterm.log_info("hoge")

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 特定のファイルが存在するかチェックするヘルパー関数
local function file_exists(name)
  local f = io.open(name, "r")
  if f then
    f:close()
    return true
  else
    return false
  end
end

--- OS環境を判別して、"mac", "WSL", "Chromebook", "Linux", "other" のいずれかを返す
function get_os_type()
  -- 1. WSL (Windows Subsystem for Linux) の判別
  -- WSL固有の環境変数が存在するかチェック
  if os.getenv("WSL_DISTRO_NAME") then
    -- wezterm.log_info("WSL")
    return "WSL"
  end

  -- 2. Chromebook (Crostini) の判別
  -- Crostini固有の環境変数が存在するかチェック
  if file_exists("/dev/.cros_milestone") then
    -- wezterm.log_info("Chromebook")
    return "Chromebook"
  end

  -- 3. unameコマンドで mac と Linux を判別
  local handle = io.popen("uname")
  if handle then
    -- コマンドの出力を取得し、末尾の改行などを削除
    local uname_output = handle:read("*a"):gsub("%s*$", "")
    handle:close()

    if uname_output == "Darwin" then
      -- wezterm.log_info("macOS")
      return "macOS" -- macOSのunameは "Darwin" を返す
    elseif uname_output == "Linux" then
      -- wezterm.log_info("Linux")
      return "Linux" -- WSLでもCrostiniでもない、素のLinux
    end
  end

  -- 4. 上記のいずれでもない場合
  -- wezterm.log_info("Other")
  return "Other"
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
else -- Linux, WSL, Chromebook
  config.font_size = 10
  config.font = wezterm.font_with_fallback({ table.unpack(font_candidates), 'Noto Sans CJK JP', 'Noto Color Emoji' })
end

-- プラットフォーム固有設定
if os == "macOS" then
  config.macos_window_background_blur = 30
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
elseif os == "Chromebook" then
  config.enable_wayland = false
  config.front_end = "OpenGL"

  -- ▼▼▼ 日本語入力(IME)のための環境変数設定 ▼▼▼
  -- Crostini/Debian環境で標準的なFcitx5を想定
  config.set_environment_variables = {
  GTK_IM_MODULE = 'fcitx',
  QT_IM_MODULE = 'fcitx',
  XMODIFIERS = '@im=fcitx',
}
end
-- Windowsの起動設定は「起動用ファイル」が担当するため、ここには記述しません。

-- キーバインド
config.keys = {
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}
if os == "macOS" then
  local mac_keys = {
    { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
    { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
    { key = 'q', mods = 'CMD', action = act.QuitApplication },
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

