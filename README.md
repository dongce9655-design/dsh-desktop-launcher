# dsh-desktop-launcher

一键启动 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) Web GUI 的 Windows 启动器。

双击桌面快捷方式即可启动 `dsh web` 并自动打开浏览器——不需要再打开 PowerShell 敲命令。

> 本项目是**独立原创实现**（MIT 许可证）。DeepSeek Harness 及其鲸鱼图标是 DeepSeek 的商标与资产，本仓库不包含、也不主张任何 DeepSeek 官方图标。官方桌面启动器功能位于 [dsh-web](https://github.com/zhu1090093659/dsh-web)（Apache-2.0）的 `dsh-desktop-launcher` 插件中，与本项目互不隶属。

## 功能

- ✅ **双击即启动**：未运行时后台静默启动 `dsh web`，等待 GUI 就绪后自动打开浏览器
- ✅ **智能探测**：GUI 已在运行时直接打开浏览器，不重复启动进程
- ✅ **无黑窗**：快捷方式以隐藏窗口运行，不弹控制台
- ✅ **一键停止**：`launcher.ps1 -Stop` 结束正在运行的 dsh web 进程
- ✅ **可自定义**：URL、dsh 命令、超时时间、图标均可配置

## 系统要求

- Windows 10 / 11（Windows PowerShell 5.1 或 PowerShell 7+）
- 已安装 DeepSeek Harness，且 `dsh` 命令在 `PATH` 中（或安装时指定 `-DshCommand` 绝对路径）

## 安装

```powershell
# 1. 克隆本项目
git clone https://github.com/dongce9655-design/dsh-desktop-launcher.git
cd dsh-desktop-launcher

# 2. 创建桌面快捷方式（默认名称 "DeepSeek Harness"，使用项目自带图标）
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1

# 可选：指定自定义图标
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -IconPath D:\path\to\my-icon.ico
```

## 使用

- **启动**：双击桌面上的「DeepSeek Harness」快捷方式
- **停止**：在 PowerShell 中运行
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File .\launcher.ps1 -Stop
  ```
- **卸载**：删除桌面快捷方式
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Uninstall
  ```

## 参数说明

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `-Url` | `http://127.0.0.1:3080` | GUI 地址，用于探测与打开 |
| `-DshCommand` | `dsh` | 启动 dsh 的命令，可填绝对路径 |
| `-TimeoutSeconds` | `60` | 等待 GUI 就绪的超时时间 |
| `-Stop` | - | 停止正在运行的 dsh web |
| `-NoOpen` | - | 启动成功后不自动打开浏览器 |
| `install.ps1 -Name` | `DeepSeek Harness` | 快捷方式显示名称 |
| `install.ps1 -IconPath` | 空 | 快捷方式图标（`.ico` 文件） |
| `install.ps1 -Uninstall` | - | 删除桌面快捷方式 |

## 许可证

[MIT](LICENSE) © 2026 xuan
