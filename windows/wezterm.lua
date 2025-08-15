-- Windows側の「起動用」wezterm.lua
-- 目的: WSLに接続し、WSL内の本体設定ファイルを読み込む

local wezterm = require 'wezterm'
local config = {}

-- 1. WezTerm起動と同時にWSLへ接続する (最重要)
-- 以前のやり取りで、この 'WSL:Ubuntu' という形式が確実であることが判明しています。
config.default_domain = 'WSL:Ubuntu'

-- 2. WSL内でchezmoiが管理している「本格的な」設定ファイルを読み込む
-- =================================================================
-- ▼▼▼ あなたのWSL環境のユーザー名に書き換えてください ▼▼▼
local wsl_user = '[あなたのWSL環境のユーザー名]'
-- ▲▲▲ あなたのWSL環境のユーザー名に書き換えてください ▲▲▲
-- =================================================================
local wsl_config_path = string.format('//wsl$/Ubuntu/home/%s/.config/wezterm/wezterm.lua', wsl_user)

-- ファイルが存在するか確認してから読み込む
-- これでWSLが停止している場合でもWezTerm自体はエラーなく立ち上がります
local f = io.open(wsl_config_path, "r")
if f then
  f:close()
  -- pcallで安全に読み込みを実行
  local ok, wsl_config = pcall(dofile, wsl_config_path)
  if ok and type(wsl_config) == 'table' then
    -- 起動用ファイルの設定(default_domain)を上書きしないように設定を結合する
    for key, value in pairs(wsl_config) do
      if config[key] == nil then
        config[key] = value
      end
    end
  end
end

-- 最終的な設定を返す

return config
