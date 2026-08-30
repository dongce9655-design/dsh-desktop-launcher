@echo off
rem Stop a running DeepSeek Harness Web GUI instance.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0launcher.ps1" -Stop
