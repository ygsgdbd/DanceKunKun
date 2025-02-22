# DanceKunKun 🕺

[![Release](https://img.shields.io/github/v/release/ygsgdbd/DanceKunKun)](https://github.com/ygsgdbd/DanceKunKun/releases/latest)
[![License](https://img.shields.io/github/license/ygsgdbd/DanceKunKun)](LICENSE)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue.svg?style=flat&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg?style=flat)](https://www.apple.com/macos)
[![macOS](https://img.shields.io/badge/macOS-13.0+-orange.svg?style=flat&logo=apple&logoColor=white)](https://www.apple.com/macos)

> 🕺 A fun macOS menu bar app featuring a dancing KunKun that grooves to your CPU usage! Built with SwiftUI and love ❤️
> 
> 一个有趣的 macOS 菜单栏应用，会随着 CPU 使用率跳舞的坤坤！使用 SwiftUI 构建 ❤️

### 灵感来源

本项目的灵感来源于 RunCat。特别感谢 [RunKun](https://github.com/Kobe972/RunKun) 字体项目的贡献，它为本应用增添了独特的视觉效果。如果你在终端中也想体验唱跳，可以参考这个项目。

This project is inspired by RunCat. Special thanks to the [RunKun](https://github.com/Kobe972/RunKun) font project for its contribution, which adds a unique visual effect to this application. If you want to experience dancing in your terminal, you can refer to this project.

[🌍 English](#english) | [🇨🇳 中文](#chinese)

## English

🎵 A fun macOS menu bar app featuring a dancing KunKun that grooves to your CPU usage! 🎶

### ✨ Features

- 🎯 Lives in your menu bar
- 💃 Dancing animation speed changes with CPU usage
- 🖥️ Universal Binary (supports both Apple Silicon and Intel Macs)
- 🌓 Dark mode support
- 🌍 Localization support (Simplified Chinese, Traditional Chinese, English)

### 📋 Preview

<div align="center">
  <img src="Screenshots/dance.gif" width="200" alt="Dancing Preview">
  <p><em>Dancing with CPU usage</em></p>
</div>

### 📋 Requirements

- 🍎 macOS 13.0 or later
- 💻 Apple Silicon or Intel Mac

### 📥 Installation

#### Option 1: Manual Installation

1. 📦 Download the latest `DanceKunKun.dmg` from [Releases](../../releases)
2. 💿 Open the DMG file
3. 📱 Drag DanceKunKun to your Applications folder
4. 🚀 Launch DanceKunKun from Applications
5. 🎉 Enjoy the dance! 

#### Option 2: Homebrew

```bash
# Install app
brew install --cask ygsgdbd/tap/dancekunkun
```

### 🛠️ Build from Source

1. ⚙️ Install [Tuist](https://docs.tuist.io/documentation/tuist/installation)
2. 📂 Clone the repository:
```bash
git clone https://github.com/yourusername/DanceKunKun.git
cd DanceKunKun
```

3. 🔨 Generate Xcode project:
```bash
tuist generate
```

4. 🎯 Open the project and build

## Chinese

🎵 一个有趣的 macOS 菜单栏应用，会随着 CPU 使用率跳舞的坤坤！🎶

### ✨ 功能特点

- 🎯 常驻菜单栏
- 💃 舞蹈速度随 CPU 使用率变化
- 🖥️ 通用二进制（同时支持 Apple Silicon 和 Intel Mac）
- 🌓 支持深色模式
- 🌍 支持本地化（简体中文、繁体中文、英文）

### 📋 预览

<div align="center">
  <img src="Screenshots/dance.gif" width="200" alt="舞蹈预览">
  <p><em>坤坤随着 CPU 使用率跳舞</em></p>
</div>

### 📋 系统要求

- 🍎 macOS 13.0 或更高版本
- 💻 Apple Silicon 或 Intel Mac

### 📥 安装方法

#### 方式一：手动安装

1. 📦 从 [Releases](../../releases) 页面下载最新的 `DanceKunKun.dmg`
2. 💿 打开 DMG 文件
3. 📱 将 DanceKunKun 拖到应用程序文件夹
4. 🚀 从应用程序文件夹启动 DanceKunKun
5. 🎉 享受舞蹈吧！

#### 方式二：Homebrew

```bash
# 安装应用
brew install --cask ygsgdbd/tap/dancekunkun
```

### 🛠️ 从源码构建

1. ⚙️ 安装 [Tuist](https://docs.tuist.io/documentation/tuist/installation)
2. 📂 克隆仓库：
```bash
git clone https://github.com/yourusername/DanceKunKun.git
cd DanceKunKun
```

3. 🔨 生成 Xcode 项目：
```bash
tuist generate
```

4. 🎯 打开项目并构建
