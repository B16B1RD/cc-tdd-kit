#!/bin/bash
set -e

# cc-tdd-kit インストーラー
VERSION="0.1.0"
REPO_URL="https://github.com/B16B1RD/cc-tdd-kit"
BRANCH="${CC_TDD_KIT_BRANCH:-main}"

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎯 cc-tdd-kit インストーラー v${VERSION}${NC}"
echo "========================================"

# 依存関係チェック
check_dependencies() {
    local missing_deps=()
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        missing_deps+=("curl または wget")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}❌ エラー: 以下のツールが必要です:${NC}"
        printf '%s\n' "${missing_deps[@]}"
        exit 1
    fi
}

# インストール先の選択
select_install_location() {
    echo -e "\n${YELLOW}インストール先を選択してください:${NC}"
    echo "1) ユーザー用 (~/.claude/commands/) - すべてのプロジェクトで使える"
    echo "2) プロジェクト用 (.claude/commands/) - このプロジェクトのみ"
    echo
    read -p "選択 [1/2] (デフォルト: 1): " INSTALL_CHOICE
    
    if [ "${INSTALL_CHOICE}" = "2" ]; then
        INSTALL_DIR=".claude/commands"
        INSTALL_TYPE="project"
        
        # ホームディレクトリチェック
        if [ "$PWD" = "$HOME" ]; then
            echo -e "${RED}❌ エラー: ホームディレクトリではプロジェクト用インストールできません${NC}"
            echo "プロジェクトディレクトリに移動してから再実行してください"
            exit 1
        fi
        
        echo -e "${GREEN}📁 プロジェクト用としてインストールします: $PWD/$INSTALL_DIR${NC}"
    else
        INSTALL_DIR="$HOME/.claude/commands"
        INSTALL_TYPE="user"
        echo -e "${GREEN}📁 ユーザー用としてインストールします: $INSTALL_DIR${NC}"
    fi
}

# ファイルのダウンロード
download_file() {
    local url=$1
    local output=$2
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output"
    else
        echo -e "${RED}❌ ダウンロードツールが見つかりません${NC}"
        return 1
    fi
}

# インストール実行
install_tdd_kit() {
    echo -e "\n${BLUE}📦 ディレクトリを作成中...${NC}"
    mkdir -p "$INSTALL_DIR/shared"
    mkdir -p "$INSTALL_DIR/tdd"
    
    # 一時ディレクトリの作成
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT
    
    echo -e "${BLUE}📥 ファイルをダウンロード中...${NC}"
    
    # 共通リソースのダウンロード
    local shared_files=(
        "kent-beck-principles.md"
        "mandatory-gates.md"
        "project-verification.md"
        "error-handling.md"
        "commit-rules.md"
    )
    
    for file in "${shared_files[@]}"; do
        echo -n "  - shared/$file ... "
        if download_file "$REPO_URL/raw/$BRANCH/src/shared/$file" "$INSTALL_DIR/shared/$file"; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗${NC}"
            echo -e "${RED}❌ ダウンロード失敗: $file${NC}"
            exit 1
        fi
    done
    
    # メインコマンドのダウンロード
    local main_files=(
        "tdd.md"
        "tdd-quick.md"
    )
    
    for file in "${main_files[@]}"; do
        echo -n "  - $file ... "
        if download_file "$REPO_URL/raw/$BRANCH/src/commands/$file" "$TEMP_DIR/$file"; then
            # インストールタイプに応じてパスを調整
            if [ "$INSTALL_TYPE" = "project" ]; then
                sed -i.bak 's|~/.claude/commands/shared/|.claude/commands/shared/|g' "$TEMP_DIR/$file" && rm -f "$TEMP_DIR/$file.bak"
            fi
            cp "$TEMP_DIR/$file" "$INSTALL_DIR/$file"
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗${NC}"
            echo -e "${RED}❌ ダウンロード失敗: $file${NC}"
            exit 1
        fi
    done
    
    # サブコマンドのダウンロード
    local subcommands=(
        "init.md"
        "story.md"
        "plan.md"
        "run.md"
        "status.md"
        "review.md"
    )
    
    for file in "${subcommands[@]}"; do
        echo -n "  - tdd/$file ... "
        if download_file "$REPO_URL/raw/$BRANCH/src/subcommands/tdd/$file" "$TEMP_DIR/$file"; then
            # インストールタイプに応じてパスを調整
            if [ "$INSTALL_TYPE" = "project" ]; then
                sed -i.bak 's|~/.claude/commands/shared/|.claude/commands/shared/|g' "$TEMP_DIR/$file" && rm -f "$TEMP_DIR/$file.bak"
            fi
            cp "$TEMP_DIR/$file" "$INSTALL_DIR/tdd/$file"
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗${NC}"
            echo -e "${RED}❌ ダウンロード失敗: $file${NC}"
            exit 1
        fi
    done
    
    # 設定ファイルの作成
    echo -e "\n${BLUE}⚙️  設定ファイルを作成中...${NC}"
    cat > "$INSTALL_DIR/.cc-tdd-kit.json" << EOF
{
    "version": "$VERSION",
    "installed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "installation_type": "$INSTALL_TYPE",
    "install_directory": "$INSTALL_DIR",
    "repository": "$REPO_URL",
    "branch": "$BRANCH"
}
EOF
    
    echo -e "${GREEN}✅ 設定ファイルを作成しました${NC}"
}

# アンインストール機能
uninstall_tdd_kit() {
    echo -e "${YELLOW}🗑️  cc-tdd-kit をアンインストールします${NC}"
    
    # 設定ファイルから情報を読み取る
    for dir in "$HOME/.claude/commands" ".claude/commands"; do
        if [ -f "$dir/.cc-tdd-kit.json" ]; then
            echo -e "${BLUE}アンインストール対象: $dir${NC}"
            read -p "本当にアンインストールしますか？ [y/N]: " confirm
            
            if [[ $confirm =~ ^[Yy]$ ]]; then
                # ファイルの削除
                rm -rf "$dir/shared"
                rm -rf "$dir/tdd"
                rm -f "$dir/tdd.md"
                rm -f "$dir/tdd-quick.md"
                rm -f "$dir/.cc-tdd-kit.json"
                
                # ディレクトリが空なら削除
                if [ -z "$(ls -A "$dir")" ]; then
                    rmdir "$dir"
                fi
                
                echo -e "${GREEN}✅ アンインストール完了${NC}"
            else
                echo "アンインストールをキャンセルしました"
            fi
        fi
    done
}

# アップデート機能
update_tdd_kit() {
    echo -e "${BLUE}🔄 cc-tdd-kit を更新中...${NC}"
    
    # 既存のインストールを探す
    for dir in "$HOME/.claude/commands" ".claude/commands"; do
        if [ -f "$dir/.cc-tdd-kit.json" ]; then
            INSTALL_DIR="$dir"
            INSTALL_TYPE=$(grep -o '"installation_type": "[^"]*"' "$dir/.cc-tdd-kit.json" | cut -d'"' -f4)
            echo -e "${GREEN}既存のインストールを検出: $dir (${INSTALL_TYPE}用)${NC}"
            install_tdd_kit
            return
        fi
    done
    
    echo -e "${RED}❌ 既存のインストールが見つかりません${NC}"
    echo "新規インストールを実行してください"
    exit 1
}

# メイン処理
main() {
    case "${1:-}" in
        uninstall|--uninstall|-u)
            uninstall_tdd_kit
            ;;
        update|--update|-U)
            check_dependencies
            update_tdd_kit
            ;;
        version|--version|-v)
            echo "cc-tdd-kit installer version $VERSION"
            ;;
        help|--help|-h)
            echo "使用方法: bash install.sh [オプション]"
            echo ""
            echo "オプション:"
            echo "  (なし)               新規インストール"
            echo "  uninstall, -u        アンインストール"
            echo "  update, -U           アップデート"
            echo "  version, -v          バージョン表示"
            echo "  help, -h             このヘルプを表示"
            ;;
        *)
            check_dependencies
            select_install_location
            install_tdd_kit
            
            # 完了メッセージ
            echo -e "\n${GREEN}========================================${NC}"
            echo -e "${GREEN}🎉 cc-tdd-kit のインストール完了！${NC}"
            echo -e "${GREEN}========================================${NC}"
            echo
            echo -e "${BLUE}インストール先:${NC} $INSTALL_DIR"
            echo -e "${BLUE}インストールタイプ:${NC} $INSTALL_TYPE"
            echo
            echo -e "${YELLOW}使い方:${NC}"
            echo "1. プロジェクトディレクトリで Claude Code を開始:"
            echo -e "   ${GREEN}cd my-project && claude${NC}"
            echo
            echo "2. クイックスタート:"
            echo -e "   ${GREEN}/tdd-quick \"作りたいものを3行で説明\"${NC}"
            echo
            echo "3. 通常の使い方:"
            echo -e "   ${GREEN}/tdd:init${NC}"
            echo -e "   ${GREEN}/tdd:story \"要望\"${NC}"
            echo -e "   ${GREEN}/tdd:plan 1${NC}"
            echo -e "   ${GREEN}/tdd:run${NC}"
            echo
            echo -e "${BLUE}詳細: /tdd${NC}"
            echo
            if [ "$INSTALL_TYPE" = "user" ]; then
                echo "✨ どのプロジェクトでも使えるようになりました！"
            else
                echo "✨ このプロジェクト専用にインストールされました！"
            fi
            echo
            echo -e "${GREEN}Happy TDD! 🚀${NC}"
            ;;
    esac
}

# 実行
main "$@"
