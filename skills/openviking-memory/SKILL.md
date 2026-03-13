---
name: openviking-memory
description: |
  OpenViking 多 Agent 记忆管理系统。实现 L0/L1/L2 三层记忆架构和 PO/P1/P2 生命周期标签。
  用于：
  1. Agent 加载自己的记忆 (L0/L1/L2)
  2. 读取跨 Agent 共享记忆
  3. 管理记忆生命周期
  4. 按需加载不同层级的记忆
---

# OpenViking Memory System

## 记忆结构

```
/workspace/memory/
├── main/           # 主 Agent
│   ├── .abstract      # L0: 一句话摘要 (~100 tokens)
│   ├── .overview.md  # L1: 核心概览 (~2k tokens)
│   ├── details/      # L2: 完整详情
│   ├── memories/     # 个人记忆
│   ├── resources/    # 资源
│   └── skills/      # 技能
├── coder/         # Coder Agent
├── researcher/    # Researcher Agent  
├── analyst/       # Analyst Agent
└── shared/        # 跨 Agent 共享层
    ├── .abstract
    ├── .overview.md
    ├── memories/
    ├── resources/
    └── knowledge/
```

## 记忆层级

| 层级 | 文件 | 大小 | 加载时机 |
|------|------|------|----------|
| **L0** | `.abstract` | ~100 tokens | 始终加载（快速检索） |
| **L1** | `.overview.md` | ~2k tokens | 任务规划时加载 |
| **L2** | `details/*` | 完整 | 必要时深度阅读 |

## 生命周期标签

- **P0**: 活跃 - 当前使用的 Agent/记忆
- **P1**: 备用 - 保留但不活跃
- **P2**: 归档 - 已归档

## 使用方法

### 1. 加载当前 Agent 记忆

```
当前 Agent: {agent_id}

L0 摘要:
{读取 /workspace/memory/{agent_id}/.abstract}

L1 概览:
{读取 /workspace/memory/{agent_id}/.overview.md}

共享记忆:
{读取 /workspace/memory/shared/.abstract}
{读取 /workspace/memory/shared/.overview.md}
```

### 2. 按需加载 L2 记忆

当 L0/L1 无法回答时，加载 L2:
```
L2 详情:
{列出 /workspace/memory/{agent_id}/details/}
{读取相关文件}
```

### 3. 写入新记忆

```
# 添加 L2 记忆
{写入 /workspace/memory/{agent_id}/details/YYYYMMDD_HHMMSS.md}

# 更新 L0/L1
{更新 /workspace/memory/{agent_id}/.abstract}
{更新 /workspace/memory/{agent_id}/.overview.md}
```

## 管理命令

```bash
# 查看记忆
./memory/manage.sh list

# 添加记忆
./memory/manage.sh add coder L2 "内容"

# 设置生命周期
./memory/manage.sh lifecycle coder P1

# 同步共享记忆
./memory/manage.sh sync
```
