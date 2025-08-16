# My Dotfiles

個人の開発環境（dotfiles）を[chezmoi](https://www.chezmoi.io/)で管理するためのリポジトリです。

---

## 概要

macOSやLinux (Chromebook, WSL2など) 上で、一貫性のある快適なCLI体験を提供することを目指します。
[Homebrew](https://brew.sh/)によるパッケージ管理と、[zsh](https://www.zsh.org/) + [Zinit](https://github.com/zdharma-continuum/zinit)による柔軟なシェル環境を基盤としています。

### 主な導入ツールと設定

*   **シェル**: `zsh`
*   **パッケージ管理**: `Homebrew`
*   **ターミナル**:
    *   `lsd`: `ls`コマンドをモダンでカラフルな表示に強化
    *   `fzf`: 強力な曖昧検索ツール
    *   `tmux`: ターミナルマルチプレクサ
    *   `fastfetch`: システム情報を表示するツール
    *   `starship`: プロンプトをカスタマイズするツール
*   **Git連携**:
    *   `gh`: GitHub CLI
    *   `tig`: CUIでGitを操作するツール
    *   `git-delta`: `git diff`の表示を分かりやすくするツール
*   **zshプラグイン**:
    *   `fast-syntax-highlighting`: コマンドのシンタックスハイライト
    *   `zsh-autosuggestions`: コマンド履歴に基づく入力補完
    *   `zsh-completions`: 各種コマンドの補完を強化
    *   `anyframe`: コマンド履歴やディレクトリ履歴を`fzf`でインタラクティブに検索

---

## 新しいマシンへのセットアップ手順

### Step 0: GitHubへのSSH接続準備

このリポジトリはSSH経由でアクセスするため、最初に一時的なSSHキーを新しいマシンで作成し、GitHubに登録します。

1.  **新しいSSHキーを作成**:
    ```bash
    ssh-keygen -t ed25519 -C "bootstrap-key-for-new-machine"
    ```
2.  **ssh-agentを起動し、キーを追加**:
    ```bash
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```
3.  **公開鍵をコピー**:
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```
4.  **GitHubに公開鍵を登録**:
    [GitHubのSSHキー設定画面](https://github.com/settings/keys)で、コピーした公開鍵を登録します。
5.  **接続を確認**:
    ```bash
    ssh -T git@github.com
    ```
    `Hi <Your-Username>! ...`というメッセージが表示されれば成功です。

---

### Step 1: 手作業による下準備（OS別）

#### on macOS

1.  **Homebrewをインストール**:
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
2.  **`brew`コマンドにパスを通す**:
    インストール後の指示に従います。Apple Siliconの場合は通常以下のコマンドです。
    ```bash
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ```

#### on Linux (Debian / Ubuntu / Chromebook)

1.  **必須パッケージをインストール**:
    ```bash
    sudo apt update && sudo apt upgrade -y && sudo apt install -y build-essential curl file git
    ```
2.  **Homebrewをインストール**:
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
3.  **`brew`コマンドにパスを通す**:
    インストール後の指示に従います。
    ```bash
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ```
4.  **Zshをインストールし、デフォルトシェルに変更**:
    ```bash
    sudo apt install -y zsh
    chsh -s $(which zsh)
    ```
    **重要**: 設定を反映させるため、一度ログアウトして再ログインしてください。

---

### Step 2: dotfilesの展開（自動化）

1.  **chezmoiとBitwarden CLIをインストール**:
    ```bash
    brew install chezmoi bitwarden-cli
    ```
2.  **Bitwardenにログイン**:
    `chezmoi`がGitの設定などで使用する個人情報（名前、メールアドレス）を安全に取得するために`bw` (Bitwarden CLI) を使います。
    ```bash
    bw login
    ```
    その後、セッションキーを取得して環境変数に設定します。
    ```bash
    export BW_SESSION=$(bw unlock --raw)
    ```
3.  **chezmoiを実行してdotfilesを展開**:
    `<YOUR_GITHUB_URL>`をあなたのリポジトリURLに置き換えて実行してください。
    ```bash
    chezmoi init <YOUR_GITHUB_URL> --apply
    ```
    このコマンドが、リポジトリのclone、`Brewfile`に基づくパッケージのインストール、`zinit`のインストール、設定ファイルの配置まで全てを自動で行います。

4.  **ターミナルを再起動**:
    全ての変更を完全に読み込むため、ターミナルを再起動してください。セットアップはこれで完了です。

---

## Windows環境でのセットアップ

基本的なセットアップは上記の手順に従いますが、Windowsの場合は追加で以下の作業が必要です。
詳細は[windows/README.md](windows/README.md)を参照してください。

---

## 導入される主な設定

このdotfilesを適用すると、主に以下の設定が有効になります。

### `zsh`エイリアス

| エイリアス | コマンド | 説明 |
|:---|:---|:---|
| `g` | `git` | `git`コマンド |
| `l` | `lsd` | `lsd`によるファイル一覧表示 |
| `ll` | `lsd -l` | 詳細表示 |
| `la` | `lsd -a` | 隠しファイルを含む一覧 |
| `lla`| `lsd -la`| 隠しファイルを含む詳細表示 |
| `lt` | `lsd --tree`| ツリー表示 |
| `cat`| `bat` | `cat`の代替として`bat`を使用 |
| `t` | `tmux` | `tmux`の起動 |
| `tl`| `tmux ls` | `tmux`のセッション一覧表示 |
| `tn`| `tmux new -s` | `tmux`の新規セッション作成 |
| `ta` | `tmux attach -t` | `tmux`のセッションにアタッチ |
| `tk`| `tmux kill-session -t` | `tmux`のセッションを終了 |

### `zsh`キーバインド

| キーバインド | 機能 |
|:---|:---|
| `Ctrl + x` `k` | `kill`コマンドを`fzf`でインタラクティブに実行 |
| `Ctrl + x` `d` | ディレクトリ履歴を`fzf`で検索・移動 |
| `Ctrl + r` | コマンド履歴を`fzf`で検索・挿入 |

### `git`エイリアス

| エイリアス | コマンド | 説明 |
|:---|:---|:---|
| `st` | `status` | 変更状態の確認 |
| `co` | `checkout` | ブランチやコミットの切り替え |
| `br` | `branch` | ブランチの操作 |
| `ci` | `commit` | 変更をコミット |

### ターミナル環境

#### wezterm

ターミナルエミュレータ`wezterm`の設定ファイルです。LinuxとWindowsで共通の設定を管理しています。

- `dot_config/wezterm/wezterm.lua`: Linux向けの設定
- `windows/wezterm.lua`: Windows向けの設定

#### tmux

`tmux`のプレフィックスキーは `Ctrl + t` に設定されています。

| キーバインド | 機能 |
|:---|:---|
| `Ctrl + t` `-` | ペインを水平分割 |
| `Ctrl + t` `\|` | ペインを垂直分割 |
| `Ctrl + t` `h/j/k/l` | ペインを移動 |
| `Ctrl + t` `H/J/K/L` | ペインをリサイズ |
| `Ctrl + t` `n/p` | 次/前のウィンドウへ移動 |
| `Ctrl + t` `c` | 新しいウィンドウを作成 |
| `Ctrl + t` `w` | ウィンドウ一覧を表示 |

#### tig

`tig`では、より直感的な操作のためにキーバインドをいくつか変更しています。

| キー | アクション | 説明 |
|---|---|---|
| `g` | `move-first-line` | ファイルの先頭に移動する |
| `G` | `move-last-line` | ファイルの末尾に移動する |
| `E` | `view-grep` | grep検索を開始する |
| `<Esc>g` | `:toggle commit-title-graph` | コミットグラフの表示/非表示を切り替える |
