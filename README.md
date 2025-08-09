# My Dotfiles

個人の開発環境を管理するためのdotfilesです。
[chezmoi](https://www.chezmoi.io/) を使って管理しています。

---

## 概要

このdotfilesは、以下の環境で一貫したCLI体験を提供することを目指します。

* macOS
* Linux (Chromebook, WSL2など)

主な管理対象は `zsh`, `vim`, `git`, `homebrew` などです。

---

## 新しいマシンへのセットアップ手順

新しいマシンをセットアップする際は、以下の手順に従ってください。

### Step 1: 手作業による下準備（OS別）

#### on macOS

1.  **Homebrewをインストールします。**
    ターミナルを開き、以下のコマンドを実行します。これにより、Xcode Command Line Tools（`git`を含む）も自動でインストールされます。
    ```bash
    /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
    ```

#### on Linux (Debian / Ubuntu / Chromebook)

1.  **システムを最新の状態に更新します。**
    ```bash
    sudo apt update && sudo apt upgrade -y
    ```

2.  **必須パッケージをインストールします。**
    ```bash
    sudo apt install -y build-essential curl file git
    ```

3.  **Homebrewをインストールします。**
    ```bash
    /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
    ```
    インストール後、指示に従ってPATHを通してください。

4.  **Zshをインストールし、デフォルトシェルに変更します。**
    ```bash
    # Zshのインストール
    sudo apt install -y zsh

    # デフォルトシェルに設定
    chsh -s $(which zsh)
    ```
    **重要:** 設定を反映させるため、ここで一度 **ログアウトして再ログイン** するか、マシンを再起動してください。

---

### Step 2: dotfilesの展開（自動化）

下準備が終わったら、ここからは自動で環境が構築されます。

1.  **chezmoiとBitwarden CLIをインストールします。**
    ```bash
    brew install chezmoi bitwarden-cli
    ```

2.  **chezmoiを実行してdotfilesを展開します。**
    以下のコマンドの `<YOUR_GITHUB_USERNAME>` をあなたのGitHubユーザー名に置き換えて実行してください。
    ```bash
    chezmoi init <YOUR_GITHUB_USERNAME> --apply
    ```
    このコマンドが、リポジトリのclone、設定ファイルの配置、`Brewfile`に基づくパッケージのインストールまで全て行います。

---

### Step 3: セットアップ後の手作業

1.  **Bitwardenにログインします。**
    秘密情報を`chezmoi`が取得できるように、Bitwarden CLIでログインします。
    ```bash
    bw login
    ```
    その後、セッションキーを取得して環境変数に設定します。（このセッションキーはターミナルを閉じるまで有効です）
    ```bash
    export BW_SESSION=$(bw unlock --raw)
    ```

2.  **（推奨）再度`chezmoi apply`を実行します。**
    Bitwardenから取得した秘密情報に依存するテンプレートがある場合、このコマンドで正しく反映させます。
    ```bash
    chezmoi apply
    ```

3.  **ターミナルを再起動します。**
    全ての変更と設定を完全に読み込むため、ターミナルを再起動してください。

これでセットアップは完了です。
