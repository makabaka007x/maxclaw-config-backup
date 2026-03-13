#!/bin/bash
# OpenViking-style Memory Management Script
# 实现 L0/L1/L2 三层记忆 + PO/P1/P2 生命周期

MEMORY_ROOT="/workspace/memory"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_help() {
    echo "OpenViking Memory Manager"
    echo ""
    echo "用法: $0 <command> [options]"
    echo ""
    echo "命令:"
    echo "  list [agent]     列出记忆 (可选指定 agent)"
    echo "  add <agent> <type> <content>  添加记忆"
    echo "  get <agent> <file>           获取记忆内容"
    echo "  lifecycle <agent> <P0|P1|P2> 设置生命周期"
    echo "  abstract <agent>             生成 L0 摘要"
    echo "  sync                        同步共享记忆"
    echo ""
    echo "记忆层级:"
    echo "  L0 (.abstract) - 一句话摘要 (~100 tokens)"
    echo "  L1 (.overview) - 核心概览 (~2k tokens)"
    echo "  L2 (details/) - 完整详情"
    echo ""
    echo "生命周期标签:"
    echo "  P0 - 活跃 (当前使用)"
    echo "  P1 - 备用 (保留但不活跃)"
    echo "  P2 - 归档 (已归档)"
}

cmd_list() {
    local agent=$1
    if [ -z "$agent" ]; then
        echo "=== 所有 Agent 记忆 ==="
        for dir in $MEMORY_ROOT/*/; do
            agent=$(basename "$dir")
            echo -e "\n${GREEN}[$agent]${NC}"
            echo "  L0: $(cat "$dir/.abstract" 2>/dev/null | head -5)"
            lifecycle=$(grep -i "生命周期\|lifecycle" "$dir/.abstract" 2>/dev/null | head -1)
            echo "  生命周期: $lifecycle"
        done
    else
        echo "=== [$agent] 记忆结构 ==="
        [ -f "$MEMORY_ROOT/$agent/.abstract" ] && echo "L0 (.abstract): $(cat $MEMORY_ROOT/$agent/.abstract)"
        [ -f "$MEMORY_ROOT/$agent/.overview.md" ] && echo "L1 (.overview): $(cat $MEMORY_ROOT/$agent/.overview.md)"
        echo "L2 (details):"
        ls "$MEMORY_ROOT/$agent/details/" 2>/dev/null || echo "  (空)"
    fi
}

cmd_add() {
    local agent=$1 type=$2 content=$3
    if [ -z "$agent" ] || [ -z "$type" ]; then
        echo "用法: $0 add <agent> <L0|L1|L2> <content>"
        return
    fi
    
    local dir="$MEMORY_ROOT/$agent"
    mkdir -p "$dir/details"
    
    case $type in
        L0)
            echo "# $agent - L0 Abstract"$'\n\n'"$content" > "$dir/.abstract"
            echo "L0 摘要已更新"
            ;;
        L1)
            echo "# $agent - L1 Overview"$'\n\n'"$content" > "$dir/.overview.md"
            echo "L1 概览已更新"
            ;;
        L2)
            local name=$(date +%Y%m%d_%H%M%S).md
            echo "$content" > "$dir/details/$name"
            echo "L2 详情已添加: $name"
            ;;
    esac
}

cmd_lifecycle() {
    local agent=$1 level=$2
    if [ -z "$agent" ] || [ -z "$level" ]; then
        echo "用法: $0 lifecycle <agent> <P0|P1|P2>"
        return
    fi
    
    local file="$MEMORY_ROOT/$agent/.abstract"
    if [ ! -f "$file" ]; then
        echo "错误: Agent $agent 不存在"
        return
    fi
    
    # 更新生命周期标签
    sed -i "s/## 生命周期.*/## 生命周期: $level/" "$file"
    echo "Agent $agent 生命周期已设为 $level"
}

cmd_sync() {
    echo "=== 同步共享记忆 ==="
    echo "从共享层同步到各 Agent..."
    for agent in main coder researcher analyst; do
        mkdir -p "$MEMORY_ROOT/$agent/memories/shared"
        cp -r $MEMORY_ROOT/shared/* "$MEMORY_ROOT/$agent/memories/shared/" 2>/dev/null
        echo "  $agent <- shared ✓"
    done
    echo "同步完成"
}

# 主命令处理
case "$1" in
    list) cmd_list "$2" ;;
    add) cmd_add "$2" "$3" "$4" ;;
    lifecycle) cmd_lifecycle "$2" "$3" ;;
    sync) cmd_sync ;;
    *) show_help ;;
esac
