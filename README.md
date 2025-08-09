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

### **Step 0: GitHubへのSSH接続準備**

このリポジトリはSSH経由でのアクセスのため、最初に一時的なSSHキーを新しいマシンで作成し、GitHubに登録する必要があります。

1.  **新しいSSHキーを作成します。**
    ターミナルで以下のコマンドを実行します。パスフレーズなどを聞かれますが、すべてEnterキーを押して空のまま進めて構いません（このキーはセットアップ後に破棄できます）。
    ```bash
    ssh-keygen -t ed25519 -C "bootstrap-key-for-new-machine"
    ```

2.  **ssh-agentを起動し、キーを追加します。**
    ```bash
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```

3.  **公開鍵をコピーします。**
    以下のコマンドで表示される公開鍵の文字列（`ssh-ed25519`で始まり、`bootstrap-key...`で終わる1行）をすべてコピーしてください。
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```

4.  **GitHubに公開鍵を登録します。**
    ブラウザでGitHubを開き、[Settings > SSH and GPG keys](https://github.com/settings/keys) にアクセスします。「New SSH key」ボタンを押し、先ほどコピーした公開鍵を貼り付けて登録します。

5.  **接続を確認します。**
    以下のコマンドを実行し、`Hi <Your-Username>! You've successfully authenticated...` というメッセージが表示されれば成功です。
    ```bash
    ssh -T git@github.com
    ```

---

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
