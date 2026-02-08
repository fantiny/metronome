# 2026-02-08 节拍器设计说明

## 目标
实现 Flutter 节奏器（节拍器），用于演奏时稳定打拍子，界面现代简约扁平化。

## 功能范围（首版）
- 开始/停止
- BPM 调节（40–208，默认 120）
- 4/4 拍号
- 音色切换
- 音量滑块 + 静音
- 中心圆脉冲视觉反馈（强拍强调）
- 设置页：默认 BPM/音色/音量/静音/阻止休眠（默认开启）
- 设置持久化
- 防休眠：仅播放时启用

## 架构
采用 Clean Architecture：
- Presentation：UI + 状态管理
- Domain：接口与核心模型
- Data：具体实现（音频/持久化/唤醒）

## 核心接口
- MetronomeEngine：节拍驱动
- AudioOutput：音频输出
- SettingsRepository：设置持久化
- WakeLockService：防休眠开关

## 数据流
用户操作 → Controller → Engine 排程 → Beat 事件 → AudioOutput 播放 + UI 脉冲

## 测试
- 领域层：节拍间隔/强拍
- 数据层：设置读写、唤醒开关
- 表现层：状态切换、BPM 更新
