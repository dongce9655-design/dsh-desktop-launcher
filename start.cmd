@echo off
rem One-click launcher for DeepSeek Harness Web GUI (no shortcut needed).
rem Double-click this file, or pass extra arguments straight through, e.g.:
rem   start.cmd -Stop
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0launcher.ps1" %*
