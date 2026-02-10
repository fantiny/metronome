# 项目进度（PROJECT_NAMAGE）

- 2026-02-08：初始化 Git 仓库，创建 doc/docs 目录与需求、计划、进度、记忆文档。
- 2026-02-08：生成 Flutter 工程骨架，完善 .gitignore 与依赖，建立分层目录结构，完成节拍引擎首个 TDD 测试与实现。
- 2026-02-08：完成领域层设置模型与接口定义（SettingsRepository/AudioOutput/WakeLockService），并通过 TDD 测试。
- 2026-02-08：完成数据层实现（SharedPreferences、WakelockPlus、JustAudioOutput），生成基础点击音资源，并通过 TDD 测试。
- 2026-02-08：完成表现层主界面与设置页，实现防休眠逻辑，补充控制器与 Widget 测试。
- 2026-02-08：全量测试通过（flutter test）。
- 2026-02-08：修复 Web 多次节拍无声问题（播放前 pause），新增强拍标记与节拍指示点，完成 Web 联调。
- 2026-02-08：启用 Windows Desktop 平台并生成 windows 目录。
- 2026-02-09：Android 构建启用 MultiDex（方法数超 64K），模拟器 Pixel_9_Pro_XL 测试通过。
- 2026-02-09：补充 iOS 测试流程说明（macOS + Xcode 环境）。
- 2026-02-10：GitHub 仓库已创建并推送，默认分支切换为 main，清理 feature/metronome 分支。

## iOS 测试流程（macOS + Xcode）

### 前置准备
- 安装 Xcode（App Store）
- 执行 `xcode-select --install` 安装命令行工具
- 首次启动 Xcode 完成初始化
- 运行 `flutter doctor -v`，确保 iOS toolchain 通过

### 拉起工程
- 将项目复制/拉取到 Mac
- 执行 `flutter pub get`

### 模拟器运行
```bash
flutter emulators
flutter emulators --launch <name>
flutter run -d <simulator-id>
```

### 真机运行（需 Apple ID）
- 使用 Xcode 打开 `ios/Runner.xcworkspace`
- 选择真机设备
- Xcode → Signing & Capabilities 选择你的 Team（自动签名）
- 回到终端执行：
```bash
flutter run -d <device-id>
```

### 常见问题排查
- 签名失败：在 Xcode 登录 Apple ID 并启用自动签名
- Pod 依赖问题：`cd ios && pod install`

## 当前进度总结（2026-02-09）

- Android：`minSdkVersion` 已提升到 19，已启用 MultiDex；模拟器 Pixel_9_Pro_XL 运行通过。
- 构建：Gradle 代理已配置（127.0.0.1:7890），并处理过分发包下载中断问题。
- iOS：已补充完整测试流程（需 macOS + Xcode）。
- 仍待完成：在 macOS 上进行 iOS 真机/模拟器实际验证。
