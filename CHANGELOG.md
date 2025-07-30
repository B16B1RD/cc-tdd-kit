# Changelog

All notable changes to cc-tdd-kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 今後の予定

- 今後追加される機能をここに記載

## [0.1.12] - 2025-07-30

### Added

- 🚀 **スラッシュコマンドのClaude Code仕様準拠**
  - `/tdd-quick`コマンドにYAMLフロントマター追加
  - 実行可能な形式への完全準拠

- 📁 **プロジェクト構造ジェネレーター機能**
  - モダンなWeb App、API Server、CLI Tool構造の自動生成
  - 言語別の最適なディレクトリ構造とファイル配置

- 📝 **CLAUDE.md自動生成機能**
  - プロジェクトタイプに応じた最適な設定生成
  - 基本コマンドとアーキテクチャ情報の自動記載

- ✅ **品質ゲート機能**
  - 包括的な品質チェック機能の追加
  - テスト、リント、ビルドの統合実行

### Fixed

- 🔧 **src/shared/ファイルの形式変換**
  - bash関数からドキュメント形式への変換
  - Claude Codeの実行モデルへの完全準拠

### Removed

- 📦 **npm関連ファイルの削除**
  - package.jsonとpackage-lock.jsonを削除
  - 依存関係の簡素化

## [0.1.11] - 2025-07-29

### Fixed

- 🔧 **ShellCheck SC2038エラーを修正**
- 🔄 **GitHub Actions markdownlintをnpm scriptに変更**

### Added

- 🎯 **/tdd-quickに機能改善選択肢と詳細収集機能を追加**
- 💬 **/tdd:runのフィードバック収集機能を大幅に強化**
- 📂 **一時ファイル用ディレクトリ (tmp/) を追加**
- 📜 **スラッシュコマンド仕様書とベストプラクティスを追加**
- 🔄 **リリース自動化スクリプトを追加**

### Enhanced

- 🔁 **Kent Beck流の完全なフィードバックループを/tdd-quickに実装**
- 📋 **リリース管理ルールとCLAUDE.md開発ブランチ運用を追加**

## [0.1.10] - 2025-07-28

### Fixed

- 🌐 **GitHub Actionsでのレート制限エラー対策を実装**

## [0.1.9] - 2025-07-28

### Changed

- 📄 **不要なドキュメントファイルを削除しREADMEを簡潔化**

## [0.1.8] - 2025-07-25

### Fixed

- 📝 **Markdownの太字表記を修正（鉤括弧内で正しく表示されるように）**

## [0.1.7] - 2025-07-25

### Enhanced

- 📖 **README.mdでカスタムスラッシュコマンドのインストールを明確化**

## [0.1.6] - 2025-07-25

### Fixed

- 📄 **CLAUDE.mdの末尾に改行を追加してmarkdownlint要件に準拠**

## [0.1.5] - 2025-07-25

### Added

- 📝 **CLAUDE.mdファイルを追加しプロジェクト概要とTDD原則を文書化**

## [0.1.4] - 2025-07-25

### Fixed

- 🔧 **Markdownlintエラーを修正**

## [0.1.3] - 2025-07-25

### Changed

- 🔢 **バージョンを0.1.3に更新**

## [0.1.2] - 2025-07-25

### Enhanced

- 📋 **Markdownlintルールを開発文書向けに最適化**

## [0.1.1] - 2025-07-25

### Fixed

- 🔧 **GitHub Actionsのブランチ設定を修正**
- ⚠️ **ShellCheckの警告を修正し、Markdownlint設定を追加**

### Added

- 📁 **binディレクトリをgitignoreに追加**

## [0.1.0] - 2025-07-25

### Added

- 初回リリース
- Kent Beck 流 TDD の完全サポート
- `/tdd-quick` コマンドによるクイックスタート機能
- 7 つの TDD コマンドのサポート
  - init: 環境初期化
  - story: ユーザーストーリー作成
  - plan: イテレーション計画
  - run: TDD 実行
  - status: 進捗確認
  - review: レビューと改善
- イテレーション単位での自動実行機能
- プロジェクトタイプ（Web/CLI/API）の自動判定
- 必須ゲートによる品質保証
- フィードバック駆動の継続的改善
- タイムアウト対策を含む堅牢な実行環境
- ユーザー用/プロジェクト用の選択可能なインストール
- 日本語対応（メッセージ、ドキュメント）

### Technical Details

- Red→Green→Refactor サイクルの厳密な実施
- Fake It 戦略（60%以上）の推奨
- Tidy First 原則（構造と振る舞いの分離）
- Git 統合（TDD/STRUCT/FEAT 等のコミットタグ）
- Playwright MCP との連携（Web 確認）

[Unreleased]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.12...HEAD
[0.1.12]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.11...v0.1.12
[0.1.11]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.10...v0.1.11
[0.1.10]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.9...v0.1.10
[0.1.9]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.8...v0.1.9
[0.1.8]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.7...v0.1.8
[0.1.7]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/B16B1RD/cc-tdd-kit/releases/tag/v0.1.0
