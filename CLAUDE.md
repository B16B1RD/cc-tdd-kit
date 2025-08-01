# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## プロジェクト概要

cc-tdd-kit は Claude Code 用の TDD 開発キットです。
Kent Beck 流の TDD 原則に基づいて、Red → Green → Refactor サイクルを厳格に実施します。
小さく始めて大きく育てる開発を支援します。

## 基本コマンド

### テスト実行

```bash
bash tests/run-tests.sh
```

### インストールテスト

```bash
# ユーザー用インストール (1を選択)
bash install.sh

# プロジェクト用インストール (2を選択)
bash install.sh

# アンインストール
bash install.sh uninstall
```

### コード品質チェック（ShellCheck利用可能時）

```bash
shellcheck install.sh
```

## アーキテクチャ

### 主要ディレクトリ構造

- `src/commands/` - メインコマンド（`/tdd`, `/tdd-quick`）
- `src/subcommands/tdd/` - TDD サブコマンド（`init`、`story`、`plan`、`run`、`status`、`review`）
- `src/shared/` - 共通リソース（Kent Beck 原則、必須ゲート、プロジェクト検証など）
- `tests/` - 自動テストスイート
- `examples/` - 使用例（api-server, cli-tool, web-app）

### 設計原則

- **Tidy First原則** - 構造的変更（[STRUCTURE]）と振る舞いの変更（[BEHAVIOR]）を厳格に分離
- **必須ゲート** - 各ステップで動作確認、受け入れ基準チェック、Git コミットを強制
- **プログレッシブ表示** - 必要な情報を必要なときに表示（`-v` オプションで詳細表示）

### TDD ワークフロー

1. `/tdd:init` - 環境初期化と Git 初期化
2. `/tdd:story` - ユーザーストーリー作成
3. `/tdd:plan` - 90 分イテレーション計画
4. `/tdd:run` - TDD 実行（連続実行 or ステップ実行）
5. `/tdd:status` - 進捗確認
6. `/tdd:review` - 品質分析とフィードバック

### インストールタイプ

- **ユーザー用** - `~/.claude/commands/` で全プロジェクトで利用可能
- **プロジェクト用** - `.claude/commands/` でプロジェクト固有カスタマイズ可能

## データ管理

各プロジェクトに `.claude/agile-artifacts/` ディレクトリが作成され、以下を管理します。

- `stories/` - ユーザーストーリー（Git 管理対象）
- `iterations/` - イテレーション計画（Git 管理対象）
- `reviews/` - レビューとフィードバック（Git 管理対象）
- `tdd-logs/` - 実行ログ（Git 管理対象外、個人用）

### Git管理方針

- チーム共有価値の高い情報（stories, iterations, reviews）は Git 管理
- 個人的な実行ログ（tdd-logs）は`.gitignore`で除外
- プロジェクトの成長過程と学習内容を追跡可能に

## Kent Beck TDD 戦略

- **Fake It 戦略**（60%以上で使用）- 最初はハードコーディングで実装
- **Triangulation** - 2 つ目のテストで一般化
- **Obvious Implementation** - 明白な場合のみ最初から正しい実装

## 品質管理

- 全テストスイートによる自動検証
- ShellCheck によるシェルスクリプト品質チェック
- インストール/アンインストール機能の統合テスト
- ファイル整合性チェック
- Markdown lint チェック（textlint 使用）

## リリース管理

### バージョニング

[Semantic Versioning](https://semver.org/) に準拠します。

- **MAJOR** - 破壊的変更（例: 0.x.x → 1.0.0）
- **MINOR** - 新機能追加（例: 0.1.x → 0.2.0）  
- **PATCH** - バグ修正・改善（例: 0.1.0 → 0.1.1）

### リリースプロセス

1. **コード変更**
   - 全テストが通ることを確認
   - Markdown lint エラーがないことを確認

2. **CHANGELOG.md更新**
   - 変更内容を該当するセクション（Added/Changed/Fixed/Removed）に具体的に記載
   - リリース日を記載（例: `## [0.2.1] - 2025-01-28`）

3. **タグ付けの注意点**
   - **必ず最新のコミット後にタグ付け**を実行
   - タグ作成前に必要な変更が全てコミット済みか確認
   - タグメッセージには簡潔な変更概要を含める

4. **実行手順**

   ```bash
   # 1. 変更をコミット
   git add -A
   git commit -m "[BEHAVIOR] 新機能の説明"
   
   # 2. CHANGELOGを更新
   # （CHANGELOG.mdを編集）
   git add CHANGELOG.md
   git commit -m "[STRUCTURE] v0.x.x CHANGELOGエントリを追加"
   
   # 3. タグ付け（最新コミットに対して）
   git tag v0.x.x -m "v0.x.x: 変更概要"
   
   # 4. プッシュ
   git push origin main
   git push origin v0.x.x
   ```

### タグ付け後の追加変更

タグ付け後に追加のコミットが発生した場合の対処法です。

- パッチバージョンとして新しいタグを作成（推奨）
- 例: v0.2.0 → v0.2.1（リント修正など）

### GitHub Actions

- Markdown lint エラーは必ずローカルで修正してからプッシュ
- CI が通らない状態でのタグ付けは避ける
