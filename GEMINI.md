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
- **概要**: zsh環境にて[chezmoi](https://www.chezmoi.io/)と[Homebrew](https://brew.sh/)、[Zinit](https://github.com/zdharma-continuum/zinit)を基盤として快適なCLI環境を構築することを目的とします。
- **使用技術**:
    - CLI環境を構築する手順は[README.md](README.md)を確認してください。
    - Homebrewによっていインストールされている各種フレームワーク/ライブラリ/アプリケーションは[dot_Brewfile](dot_Brewfile)を確認してください。
- **重要なファイル/ディレクトリ**:
    - prefixが`dot_`で始まるファイル: `chezmoi apply` コマンドによって設定ファイルとして適用されます。