# dsh-desktop-launcher

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform: Windows](https://img.shields.io/badge/platform-Windows-0078D6.svg)]()
[![PowerShell](https://img.shields.io/badge/powershell-5.1%2B-5391FE.svg)]()

[English](README.en.md) | 中文

一键启动 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) Web GUI 的 Windows 启动器。双击桌面快捷方式即可启动 `dsh web` 并自动打开浏览器——不需要再打开 PowerShell 敲命令。

> **版权说明**：本项目是独立原创实现（MIT 许可证）。DeepSeek Harness 及其鲸鱼图标是 DeepSeek 的商标与资产，本仓库不包含、也不主张任何 DeepSeek 官方图标。官方桌面启动器功能位于 [dsh-web](https://github.com/zhu1090093659/dsh-web)（Apache-2.0）的 `dsh-desktop-launcher` 插件中，与本项目互不隶属。

## 功能

- ✅ **双击即启动**：未运行时后台静默启动 `dsh web`，等待 GUI 就绪后自动打开浏览器
- ✅ **智能探测**：GUI 已在运行时直接打开浏览器，不重复启动进程
- ✅ **无黑窗**：快捷方式以隐藏窗口运行，不弹控制台
- ✅ **一键停止**：`launcher.ps1 -Stop` 或双击 `stop.cmd` 结束正在运行的 dsh web
- ✅ **可自定义**：URL、dsh 命令、超时时间、图标均可配置
- ✅ **零依赖**：仅用 Windows 自带 PowerShell 与 .NET，无需安装任何额外组件

## 快速开始

### 系统要求

- Windows 10 / 11（Windows PowerShell 5.1 或 PowerShell 7+）
- 已安装 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)，且 `dsh` 命令在 `PATH` 中

### 安装（创建桌面快捷方式）

```powershell
git clone https://github.com/dongce9655-design/dsh-desktop-launcher.git
cd dsh-desktop-launcher
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

完成后桌面出现「DeepSeek Harness」快捷方式（使用项目自带鲸鱼图标）。

### 不想用快捷方式？

直接把 [`start.cmd`](start.cmd) 双击即可，或拖一个快捷方式到桌面/任务栏。

## 使用

| 操作 | 方法 |
| --- | --- |
| 启动 | 双击桌面「DeepSeek Harness」快捷方式，或双击 `start.cmd` |
| 停止 | 双击 `stop.cmd`，或 `powershell -File .\launcher.ps1 -Stop` |
| 卸载 | `powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Uninstall` |

## 参数说明

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `-Url` | `http://127.0.0.1:3080` | GUI 地址，用于探测、打开与 `-Stop` 的端口推导 |
| `-DshCommand` | `dsh` | 启动 dsh 的命令，可填绝对路径 |
| `-TimeoutSeconds` | `60` | 等待 GUI 就绪的超时时间 |
| `-Stop` | - | 停止正在运行的 dsh web |
| `-NoOpen` | - | 启动成功后不自动打开浏览器 |
| `install.ps1 -Name` | `DeepSeek Harness` | 快捷方式显示名称 |
| `install.ps1 -IconPath` | 空 | 快捷方式图标（`.ico` 文件），默认用项目自带图标 |
| `install.ps1 -Uninstall` | - | 删除桌面快捷方式 |

## 常见问题（FAQ）

**Q：双击后没有任何反应？**
A：快捷方式是隐藏窗口运行的，正常情况会自动打开浏览器。若 60 秒内未打开，多半是 `dsh` 不在 PATH——用 `install.ps1` 重新安装并先 `set PATH=%PATH%;你的dsh目录`，或在 `launcher.ps1` 里用 `-DshCommand C:\绝对\路径\dsh.cmd` 调用。

**Q：双击 `start.cmd` 会闪一下黑窗？**
A：会，因为 .cmd 本身是控制台程序。想要无黑窗体验就用 `install.ps1` 生成的桌面快捷方式（隐藏窗口模式）。

**Q：启动很慢或超时？**
A：首次启动 DSH 可能需要更长时间，可增大超时：`powershell -File .\launcher.ps1 -TimeoutSeconds 120`。

**Q：与 dsh-web 全家桶里的桌面启动器插件是什么关系？**
A：功能相似但代码完全独立。那个插件是 dsh-web 项目（Apache-2.0）的一部分，本仓库是自研实现，两者互不隶属；你桌面若已有插件生成的快捷方式，与本项目互不影响。

**Q：能自定义图标吗？**
A：可以。`install.ps1 -IconPath 你的图标.ico`；`make-icon.ps1` 可重新生成项目自带的鲸鱼剪影图标。

## 开发

```powershell
# 语法校验（CI 也执行同样的检查）
powershell -NoProfile -Command "$t=$null;$e=$null;Get-ChildItem -Filter *.ps1 | ForEach-Object {[System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$t,[ref]$e)|Out-Null;if($e.Count){$e|ForEach-Object{Write-Error $_.Message}}};Write-Host 'OK'"
```

## 许可证

[MIT](LICENSE) © 2026 xuan
