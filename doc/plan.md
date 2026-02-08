# 工作计划

## 里程碑
1. 初始化工程与目录结构（doc/docs + Flutter 工程骨架）
2. 领域层接口定义（MetronomeEngine/AudioOutput/SettingsRepository/WakeLockService）
3. 数据层实现（音频、设置、唤醒）
4. 表现层实现（主界面 + 设置页）
5. 测试与验证
6. 文档与收尾

## 执行策略
- 严格 TDD：先写测试，再写实现
- 采用 Clean Architecture 分层
- 节拍稳定优先（音频排程）
- UI 扁平化、简洁
