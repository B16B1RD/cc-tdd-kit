# ユーザーストーリーの作成

要望: $ARGUMENTS

## 実行内容

### 1. 本質分析（5つのなぜ）
要望の背景にある本質的なニーズを探ります。

### 2. ストーリー分割
以下の 3 つのリリースに分けて、段階的に価値を提供：

- **Release 0**: 最初の 30 分で見えるもの（2-3 ストーリー）
- **Release 1**: 基本的な価値（3-4 ストーリー）  
- **Release 2**: 継続的な価値（3-4 ストーリー）

### 3. ストーリー形式
```
Story X.Y: [簡潔なタイトル]
As a [役割]
I want [機能]
So that [価値]

見積もり: XX分
受け入れ基準:
- [ ] 具体的で検証可能な条件1
- [ ] 具体的で検証可能な条件2
- [ ] 具体的で検証可能な条件3

確認履歴:
- [ ] 実装時の動作確認
- [ ] 統合時の確認
```

### 4. ファイル作成
`.claude/agile-artifacts/stories/project-stories.md` に保存：
- 本質分析の結果
- ペルソナと成功指標
- リリース計画
- 各ストーリーの詳細
- プロジェクトタイプ別の確認方法

### 5. コミット
```bash
git add .claude/agile-artifacts/stories/
git commit -m "[BEHAVIOR] Create user stories for project"
```

## 原則
- **YAGNI**: 今必要ない機能は含めない
- **検証可能**: 曖昧な基準を避ける
- **段階的**: 小さく始めて大きく育てる

## 完了後
```
📝 ストーリーを作成しました！
総数: X個、推定: Y時間

次: /tdd:plan 1
```
