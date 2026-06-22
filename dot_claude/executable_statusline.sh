#!/usr/bin/env bash
# ============================================================================
# Claude Code ステータスライン
#   1行目: モデル名 / カレントディレクトリ / git ブランチ
#   2行目: 使用率プログレスバー
#            Ctx = このセッションのコンテキスト使用率 (context_window)
#            5h  = 5時間ローリング枠   (rate_limits.five_hour)
#            7d  = 週次・全モデル枠     (rate_limits.seven_day)
#            Op  = 週次・Opus 枠        (rate_limits.seven_day_opus / 枠が無ければ非表示)
#          薄いトラックの上に使用量ぶんが伸び、使うほど濃い色に (緑→黄→橙→赤)。
#          ↻ の後ろは枠がリセットされるまでの残り時間 (Ctx は時間枠が無いので↻なし)。
#
# 入力 : stdin に session データの JSON が渡される
#        (rate_limits は Pro/Max かつ最初の API 応答後にのみ出現。各枠は欠落しうる)
# 依存 : jq, awk, git(任意), date
# 互換 : bash 3.2+ を想定し mapfile 等の bash4 専用機能は使わない
# ============================================================================

# ---- 調整用パラメータ ------------------------------------------------------
BAR_WIDTH=8          # バーの文字数。狭い端末で折り返すなら小さく
FILL='█'             # 使用済み(埋まっている)セル … 濃い色
EMPTY='░'            # 未使用(トラック)セル … 薄い色
SHOW_COUNTDOWN=1     # 1=リセットまでの残り時間を表示, 0=非表示

# 使用量(%)→ 色 のしきい値。使用量が増えるほど濃い(危険な)色になる
TH_YELLOW=50         # これ以上で黄
TH_ORANGE=75         # これ以上で橙
TH_RED=90            # これ以上で赤(危険)。未満は緑
# ---------------------------------------------------------------------------

input=$(cat)

# [一時デバッグ] 直近の生入力を保存。どの rate_limits 枠が実際に来ているか確認用(不要なら削除可)
printf '%s' "$input" > "$HOME/.claude/statusline-last-input.json" 2>/dev/null

# jq が無いと何もできないので、その旨だけ出して正常終了
if ! command -v jq >/dev/null 2>&1; then
  printf 'statusline: jq が必要です (brew install jq / apt install jq)\n'
  exit 0
fi

# ---- 色定義 (256色。ESC は実バイトで埋め込む) -------------------------------
ESC=$(printf '\033')
RESET="${ESC}[0m"
BOLD="${ESC}[1m"
DIM="${ESC}[38;5;244m"        # ラベル等の控えめな文字
EMPTYCOL="${ESC}[38;5;245m"   # 未使用トラック(薄いグレー)
GREEN="${ESC}[38;5;78m"
YELLOW="${ESC}[38;5;221m"
ORANGE="${ESC}[38;5;214m"
RED="${ESC}[38;5;196m"
C_MODEL="${ESC}[38;5;75m"
C_DIR="${ESC}[38;5;110m"
C_GIT="${ESC}[38;5;108m"

NOW=$(date +%s)

# ---- JSON を 1 回の jq で取り出す ------------------------------------------
# 欠落フィールドは // "" で空行にし、行のズレを防ぐ(0 は有効値なので空を番兵に)
F=()
i=0
while IFS= read -r line; do
  F[$i]="$line"
  i=$((i + 1))
done < <(printf '%s' "$input" | jq -r '
  (.model.display_name // "Claude"),
  (.workspace.current_dir // .cwd // ""),
  (.rate_limits.five_hour.used_percentage      // ""),
  (.rate_limits.five_hour.resets_at            // ""),
  (.rate_limits.seven_day.used_percentage      // ""),
  (.rate_limits.seven_day.resets_at            // ""),
  (.rate_limits.seven_day_opus.used_percentage // ""),
  (.rate_limits.seven_day_opus.resets_at       // ""),
  (.context_window.used_percentage             // "")
')

MODEL="${F[0]:-Claude}"
CWD="${F[1]}"

# ---- カレントディレクトリをホーム基準で短縮 -------------------------------
case "$CWD" in
  "$HOME")   DIR="~" ;;
  "$HOME"/*) DIR="~${CWD#"$HOME"}" ;;
  "")        DIR="" ;;
  *)         DIR="$CWD" ;;
esac

# ---- git ブランチ (symbolic-ref は巨大リポでも一瞬なのでキャッシュ不要) -----
GIT=""
if [ -n "$CWD" ] && command -v git >/dev/null 2>&1; then
  GIT=$(git -C "$CWD" symbolic-ref --quiet --short HEAD 2>/dev/null \
        || git -C "$CWD" rev-parse --short HEAD 2>/dev/null) || GIT=""
fi

# ---- リセットまでの残り時間を整形 -----------------------------------------
fmt_dur() {
  local s=$1
  [ "$s" -lt 0 ] 2>/dev/null && s=0
  local d=$((s / 86400)) h=$(((s % 86400) / 3600)) m=$(((s % 3600) / 60))
  if   [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"
  elif [ "$m" -gt 0 ]; then printf '%dm' "$m"
  else                      printf '<1m'
  fi
}

# ---- 1 本のバーを描く : draw ラベル used_percentage resets_at -------------
draw() {
  local label="$1" used="$2" reset="$3"
  # used が数値でなければ(=この枠は無い)何も描かない
  case "$used" in
    ''|*[!0-9.]*) return 0 ;;
  esac

  # 使用量(%) を 0..100 に丸める
  local pct
  pct=$(awk -v u="$used" 'BEGIN{if(u<0)u=0; if(u>100)u=100; printf "%.0f", u}')

  # 使用済みセル数(四捨五入)
  local filled=$(((pct * BAR_WIDTH + 50) / 100))
  [ "$filled" -gt "$BAR_WIDTH" ] && filled=$BAR_WIDTH
  [ "$filled" -lt 0 ] && filled=0
  local empty=$((BAR_WIDTH - filled))

  # 使用量が多いほど濃い(危険な)色に
  local color
  if   [ "$pct" -ge "$TH_RED" ];    then color=$RED
  elif [ "$pct" -ge "$TH_ORANGE" ]; then color=$ORANGE
  elif [ "$pct" -ge "$TH_YELLOW" ]; then color=$YELLOW
  else                                   color=$GREEN
  fi

  # バー本体を組み立て(薄いトラックの上に濃い色で使用ぶんを描く)
  local bar="" i
  i=0; while [ "$i" -lt "$filled" ]; do bar="${bar}${FILL}"; i=$((i + 1)); done
  local barempty=""
  i=0; while [ "$i" -lt "$empty" ]; do barempty="${barempty}${EMPTY}"; i=$((i + 1)); done

  # リセットまでのカウントダウン
  local cdn=""
  if [ "$SHOW_COUNTDOWN" = 1 ]; then
    case "$reset" in
      ''|*[!0-9]*) ;;  # 数値でなければ表示しない
      *) cdn=" ${DIM}↻$(fmt_dur $((reset - NOW)))${RESET}" ;;
    esac
  fi

  printf '%s%s%s %s%s%s%s%s %s%3d%%%s%s' \
    "$DIM" "$label" "$RESET" \
    "$color" "$bar" "$EMPTYCOL" "$barempty" "$RESET" \
    "$color" "$pct" "$RESET" "$cdn"
}

# ---- 2 行目: 各リミットのバーを連結 ---------------------------------------
segC=$(draw "Ctx" "${F[8]}" "")    # このセッションのコンテキスト使用率(時間枠が無いので↻なし)
seg5=$(draw "5h" "${F[2]}" "${F[3]}")
seg7=$(draw "7d" "${F[4]}" "${F[5]}")
segO=$(draw "Op" "${F[6]}" "${F[7]}")

line2=""
for s in "$segC" "$seg5" "$seg7" "$segO"; do
  [ -n "$s" ] && line2="${line2:+$line2   }$s"
done
# rate_limits がまだ無い(無料枠 / セッション初期)場合の案内
[ -z "$line2" ] && line2="${DIM}使用量リミット: 最初の応答後に表示されます${RESET}"

# ---- 1 行目: モデル / ディレクトリ / git ---------------------------------
line1="${BOLD}${C_MODEL}${MODEL}${RESET}"
[ -n "$DIR" ] && line1="${line1}  ${C_DIR}${DIR}${RESET}"
[ -n "$GIT" ] && line1="${line1}  ${C_GIT}(${GIT})${RESET}"

printf '%s\n' "$line1"
printf '%s\n' "$line2"
