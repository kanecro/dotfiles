# GEMINI.md: Geminiへの指示書

## このファイルについて

このファイルは、AIアシスタントであるGeminiに対して、このプロジェクトに関するタスクを依頼する際の指示や前提条件を記述するためのものです。
Geminiがプロジェクトのコンテキストを正確に理解し、より的確なサポートを提供できるようにすることを目的としています。

## Geminiへの指示

- 新しいライブラリやフレームワークを導入する際は、事前にその必要性を確認し、プロジェクトの依存関係と互換性を考慮してください。
- 不明な点がある場合は、憶測で進めずに質問してください。
- ファイル変更を伴う作業をする場合は、必ずブランチを作成した上で実施してください。

## 変更作業のワークフロー

コードの変更や機能追加を行う際は、以下の手順で進めてください。

1.  **作業計画の提示**: 変更内容と手順を具体的に示します。
2.  **ブランチの作成**: `git checkout -b <branch_name>` で新しいブランチを作成します。
3.  **実装**: コードの変更、テストの追加・修正などを行います。
4.  **Push**: `git push origin <branch_name>` でリモートリポジトリに変更を反映します。
5.  **Pull Requestの作成**: `gh pr create` コマンドでPull Requestを作成し、レビューを依頼します。

## 主要なコマンド

### Git

- `git status`: ファイルの変更状態を確認する
- `git branch`: ブランチの一覧を表示する
- `git checkout -b <branch_name>`: ブランチを作成して切り替える
- `git add <file_path>`: ファイルをステージングする
- `git commit -m "<message>"`: 変更をコミットする
- `git push origin <branch_name>`: リモートリポジトリにPushする
- `git pull`: リモートリポジトリから最新の変更を取得する
- `git log`: コミット履歴を確認する

### GitHub CLI (gh)

- `gh pr create`: Pull Requestを作成する
- `gh pr list`: Pull Requestの一覧を表示する
- `gh pr diff`: Pull Requestの差分を表示する
- `gh pr merge`: Pull Requestをマージする
- `gh issue create`: Issueを作成する

## プロジェクトのコンテキスト

- **プロジェクト名**: dotfiles
- **概要**: zsh環境にて[chezmoi](https://www.chezmoi.io/)による設定ファイル管理を中核とし、[Homebrew](https://brew.sh/)によるパッケージ導入、[Zinit](https://github.com/zdharma-continuum/zinit)によるプラグイン管理を組み合わせ、快適でモダンなCLI環境を構築することを目的とします。
- **使用技術**:
    - **設定管理**: `chezmoi`
    - **パッケージ管理**: `Homebrew`
    - **シェル**: `zsh`
    - **zshプラグイン管理**: `Zinit`
        - `fast-syntax-highlighting`
        - `zsh-autosuggestions`
        - `zsh-completions`
        - `anyframe`
    - **主要なCLIツール**: `lsd`, `fzf`, `tmux`, `gh`, `bitwarden-cli`, `git-delta`, `starship`, `tig`, `wezterm`
    - **セットアップ手順**: [README.md](README.md)に記載
    - **Homebrewパッケージリスト**: [dot_Brewfile](dot_Brewfile)を参照
- **重要なファイル/ディレクトリ**:
    - prefixが`dot_`で始まるファイル: `chezmoi apply` コマンドによってホームディレクトリに設定ファイルとして適用されます。
    - `run_once_`で始まるスクリプト: `chezmoi apply`時に一度だけ実行されるスクリプトです。
    - `dot_config/tmux/tmux.conf`: tmuxの設定ファイルです。
    - `dot_config/wezterm/wezterm.lua`: weztermの設定ファイルです。
