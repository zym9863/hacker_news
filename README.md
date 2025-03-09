# Hacker News App

中文版 | [English](README_EN.md)

一个使用Flutter开发的Hacker News客户端应用，提供了流畅的用户体验和丰富的功能。

![Hacker News](assets/image_fx_.jpg)

## 功能特点

- **实时新闻**: 从Hacker News API获取最新的科技新闻和讨论
- **多语言支持**: 支持英文和中文界面，轻松切换语言
- **深色模式**: 内置日间/夜间主题切换功能，保护您的眼睛
- **响应式设计**: 适配各种屏幕尺寸的设备
- **下拉刷新**: 轻松获取最新内容
- **详细阅读**: 支持查看新闻详情和评论
- **外部浏览器打开**: 可以在系统浏览器中打开原始链接

## 技术架构

### 项目结构

```
lib/
├── l10n/                  # 本地化和国际化
├── models/                # 数据模型
├── providers/             # 状态管理
├── screens/               # 应用界面
├── services/              # API服务
├── theme/                 # 主题配置
├── widgets/               # 可复用组件
└── main.dart              # 应用入口
```

### 使用的技术和库

- **Flutter**: UI框架
- **Provider**: 状态管理
- **HTTP**: 网络请求
- **Timeago**: 时间格式化
- **Pull to Refresh**: 下拉刷新功能
- **Flutter Localizations**: 国际化支持

## 安装和运行

1. 确保已安装Flutter开发环境
2. 克隆此仓库
3. 安装依赖:
   ```
   flutter pub get
   ```
4. 运行应用:
   ```
   flutter run
   ```

## 截图

![Screenshot](assets/screenshot.png)

## 贡献

欢迎提交问题和拉取请求，一起改进这个应用！

## 许可证

此项目采用MIT许可证 - 详情请查看LICENSE文件
