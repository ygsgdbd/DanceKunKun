# RunKunKun

一个 macOS 状态栏工具，用于显示输入法切换动画。

## 系统要求

- macOS 13.0 或更高版本
- Xcode 15.0 或更高版本
- Tuist

## 开发环境设置

1. 安装 Tuist:
```bash
curl -Ls https://install.tuist.io | bash
```

2. 生成 Xcode 项目:
```bash
tuist generate
```

## 项目结构

- `Sources/App`: 应用程序入口和主要配置
- `Sources/Views`: SwiftUI 视图文件
- `Sources/Models`: 数据模型
- `Sources/Utils`: 工具类和扩展
- `Resources`: 资源文件
- `Tests`: 单元测试

## 使用的框架

- SwiftUI
- SwiftUIX
- Defaults
- SwifterSwift
- KeyboardShortcuts 