# dsh-desktop-launcher

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform: Windows](https://img.shields.io/badge/platform-Windows-0078D6.svg)]()
[![PowerShell](https://img.shields.io/badge/powershell-5.1%2B-5391FE.svg)]()

English | [中文](README.md)

A one-click launcher for the [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) Web GUI on Windows. Double-click a desktop shortcut to start `dsh web` and open the browser automatically — no more typing commands in PowerShell.

> **Copyright note**: This project is an independent, original implementation (MIT). DeepSeek Harness and its whale logo are trademarks and assets of DeepSeek; this repository contains no official DeepSeek artwork. The official desktop-launcher feature lives in the [dsh-web](https://github.com/zhu1090093659/dsh-web) project (Apache-2.0) and is not affiliated with this repository.

## Features

- ✅ **Double-click to start**: silently starts `dsh web` in the background when it is not running, then opens the browser once the GUI is ready
- ✅ **Smart probe**: if the GUI is already running, it just opens the browser — no duplicate process
- ✅ **No console window**: the shortcut runs with a hidden window
- ✅ **One-click stop**: `launcher.ps1 -Stop` or double-click `stop.cmd`
- ✅ **Configurable**: URL, dsh command, timeout and icon are all adjustable
- ✅ **Zero dependencies**: only built-in Windows PowerShell / .NET

## Quick start

### Requirements

- Windows 10 / 11 (Windows PowerShell 5.1 or PowerShell 7+)
- [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) installed with `dsh` on `PATH`

### Install (create a desktop shortcut)

```powershell
git clone https://github.com/dongce9655-design/dsh-desktop-launcher.git
cd dsh-desktop-launcher
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

A "DeepSeek Harness" shortcut appears on your Desktop with the bundled whale icon.

### Prefer no shortcut?

Just double-click [`start.cmd`](start.cmd), or pin it to the taskbar.

## Usage

| Action | How |
| --- | --- |
| Start | Double-click the "DeepSeek Harness" shortcut or `start.cmd` |
| Stop | Double-click `stop.cmd`, or `powershell -File .\launcher.ps1 -Stop` |
| Uninstall | `powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Uninstall` |

## Parameters

| Parameter | Default | Description |
| --- | --- | --- |
| `-Url` | `http://127.0.0.1:3080` | GUI URL; used for probing, opening and port derivation for `-Stop` |
| `-DshCommand` | `dsh` | Command that starts dsh; accepts an absolute path |
| `-TimeoutSeconds` | `60` | How long to wait for the GUI to become ready |
| `-Stop` | - | Stop the running dsh web instance |
| `-NoOpen` | - | Do not auto-open the browser after startup |
| `install.ps1 -Name` | `DeepSeek Harness` | Shortcut display name |
| `install.ps1 -IconPath` | empty | Shortcut icon (`.ico`); defaults to the bundled icon |
| `install.ps1 -Uninstall` | - | Remove the desktop shortcut |

## FAQ

**Q: Nothing happens after double-click?**
A: The shortcut runs hidden and normally opens the browser. If it does not within 60 s, `dsh` is probably not on `PATH` — re-run `install.ps1` after adding it, or call `launcher.ps1` with `-DshCommand C:\absolute\path\dsh.cmd`.

**Q: `start.cmd` flashes a console window?**
A: Yes, `.cmd` files are console programs by nature. For a windowless experience use the shortcut created by `install.ps1`.

**Q: Startup is slow or times out?**
A: The first boot can take a while; raise the timeout with `-TimeoutSeconds 120`.

**Q: Relation to the desktop-launcher plugin in dsh-web?**
A: Similar purpose, completely independent code. That plugin is part of the dsh-web project (Apache-2.0); this repository is an original implementation. Existing shortcuts from the plugin are unaffected.

**Q: Can I use my own icon?**
A: Yes — `install.ps1 -IconPath my-icon.ico`. `make-icon.ps1` regenerates the bundled whale silhouette.

## Development

```powershell
# Syntax validation (same check as CI)
powershell -NoProfile -Command "$t=$null;$e=$null;Get-ChildItem -Filter *.ps1 | ForEach-Object {[System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$t,[ref]$e)|Out-Null;if($e.Count){$e|ForEach-Object{Write-Error $_.Message}}};Write-Host 'OK'"
```

## License

[MIT](LICENSE) © 2026 xuan
