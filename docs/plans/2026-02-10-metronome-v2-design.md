# v2 设计：可定制 UI + 资源导入 + 云同步

## 目标

- 美化 UI，支持主题预设 + 中等细调（圆角、主色、按钮风格、字体大小、阴影强度）。
- 背景支持纯色/渐变/图片，图片支持内置 + 本地导入（全平台含 Web）。
- 节拍器声音支持内置 + 本地导入（全平台含 Web）。
- 强拍支持独立音色与音量。
- 使用视觉 DSL 配置驱动 UI，提供图形化编辑器 + JSON 编辑器。
- 使用 Firebase（Auth + Firestore + Storage）进行云同步。

## 非目标

- 不改变当前节拍引擎与节拍准确性逻辑。
- 不引入复杂的节奏训练或谱面系统。
- 不做多账号/付费体系。

## 关键决策

- 方案：采用 **视觉 DSL 方案（方案 B）**。
- Web 端允许用户上传导入（图片/音频）。
- 云同步：Firebase；登录：Google + Apple（Web 仅 Google）。
- 冲突策略：最后写入覆盖（按更新时间戳）。
- 离线策略：本地优先，联网后自动同步。
- 格式与上限：图片 jpg/png/webp（≤5MB），音频 mp3/wav/m4a（≤5MB）。
- 主题预设数量：5 套。
- JSON 导入导出：提供。

## 数据模型（DSL）

### ThemeConfig（根）

- `version: int`
- `name: String`
- `background: BackgroundConfig`
- `palette: PaletteConfig`
- `typography: TypographyConfig`
- `components: ComponentStyleConfig`

### BackgroundConfig

- `type: solid | gradient | image`
- `solidColor?: Color`
- `gradient?: { start: Color, end: Color, direction: String }`
- `imageAssetRef?: AssetRef`

### SoundProfile

- `normalSoundRef: AssetRef`
- `accentSoundRef: AssetRef`
- `normalVolume: double`
- `accentVolume: double`

### AssetRef

- `id: String`
- `type: image | audio`
- `source: builtin | local | remote`
- `mime: String`
- `size: int`
- `localPath?: String`
- `webCacheKey?: String`
- `remoteUrl?: String`

## 存储与同步

### 本地

- 移动/桌面：本地文件系统保存导入资源；SharedPreferences 保存元数据。
- Web：IndexedDB 存储导入资源；SharedPreferences Web 保存元数据。

### 云端（Firebase）

- Auth：Google + Apple（Web 仅 Google）。
- Firestore：
  - `users/{uid}/themes/{themeId}`
  - `users/{uid}/soundProfiles/{profileId}`
- Storage：
  - `users/{uid}/assets/{assetId}`

### 同步

- 本地立即生效 → 异步上行。
- 以 `updatedAt` 为冲突裁决，最后写入覆盖。

## UI 与交互

### 新增页面

- 主题中心：展示 5 套内置 + 用户主题；切换、复制、重命名、删除。
- 主题编辑器：背景/颜色/字体/组件分区，实时预览；支持 JSON 模式。
- 资源管理器：背景图库与音色库；支持导入、试听、删除。
- 声音配置：普通拍/强拍独立选择与音量。

### 现有页面改造

- 主界面：根据 DSL 动态主题与背景渲染。
- 设置页：增加“主题与声音”入口。

## 错误处理

- 导入时严格校验格式与大小；错误提示明确。
- 云同步失败时标记“待同步”状态，联网自动补同步。
- JSON 模式校验失败时阻止保存并提示错误位置。

## 测试计划

- 单元测试：DSL 解析/序列化、AssetRef 规则、SoundProfile 配置。
- 集成测试：导入 → 生效 → 重启恢复；离线 → 联网同步。
- 端到端：Android/Windows/Web 多端导入与展示一致性。

## 风险与对策

- Web 资源持久化：使用 IndexedDB + Blob URL 缓存。
- 包体与性能：图片与音频上限控制，必要时压缩。
- Firebase 配置复杂：提供清晰接入流程与校验脚本。

## 里程碑

1) DSL 模型与主题映射基础  
2) 本地导入与资源管理  
3) 主题编辑器与 JSON 模式  
4) Firebase 登录与云同步  
5) Web IndexedDB 支持  
6) 完整测试与验收
