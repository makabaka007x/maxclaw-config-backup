---
AIGC:
    ContentProducer: Minimax Agent AI
    ContentPropagator: Minimax Agent AI
    Label: AIGC
    ProduceID: 711ad623a28fb92dceb544bf5b4f21e4
    PropagateID: 711ad623a28fb92dceb544bf5b4f21e4
    ReservedCode1: 3045022071f5e2360fe8a792a1e9ae7bf2681ec6bed9803a54fca97e28642a4dd8e459c4022100fc3444aca8a28731689b107b322601ef33eeb7ee2e4ae49f2d786bd7ad504a7f
    ReservedCode2: 3045022037a4ae880be911d15395e3726619b1cdf90c5e00267655cff5d56fafa37a95cc022100a4e745e5c028c7b939e88391859e02c7af5313dd2db0392a43fbbb6278025372
---

# MEMORY.md

## 平台配置
- **平台**: OpenViking
- **Agent 数量**: 4 个
- **Gateway**: 已重启

## 可用 Agent
- `@coder` - 编程任务
- `@researcher` - 调研任务
- `@analyst` - 数据分析任务
- (第4个 Agent 未命名)

## 关键规则（必须遵守）
1. **禁止直接修改 openclaw.json**
   - 禁止运行: `openclaw doctor --fix`, `openclaw config fix`
   - 配置修改必须通过 `safe_config_update.mjs`
2. **忽略重复插件 ID 警告**
   - "duplicate plugin id detected" 是预期行为，无害
   - 平台本身如此配置

## 待测试
- 测试各 Agent 响应情况