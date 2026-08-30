# dsh-desktop-launcher - install.ps1
# Create (or remove) the desktop shortcut for launcher.ps1.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
#   powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -IconPath .\dsh-launcher.ico
#   powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Uninstall
[CmdletBinding()]
param(
    [string]$Name = 'DeepSeek Harness',
    [string]$IconPath = '',
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$launcher = Join-Path $scriptDir 'launcher.ps1'
$desktop = [Environment]::GetFolderPath('Desktop')
$lnk = Join-Path $desktop "$Name.lnk"

# The shortcut always runs through a real powershell.exe so the ExecutionPolicy
# of the current shell never matters for double-click use.
$powershellExe = Join-Path $PSHOME 'powershell.exe'
if (-not (Test-Path $powershellExe)) {
    $found = Get-Command powershell.exe -ErrorAction SilentlyContinue
    if ($null -eq $found) { throw 'powershell.exe was not found.' }
    $powershellExe = $found.Source
}

if ($Uninstall) {
    if (Test-Path $lnk) {
        Remove-Item $lnk -Force
        Write-Host "Removed shortcut: $lnk"
    } else {
        Write-Host "No shortcut to remove: $lnk"
    }
    return
}

if (-not (Test-Path $launcher)) {
    throw "launcher.ps1 was not found next to install.ps1: $launcher"
}
if ($IconPath -ne '' -and -not (Test-Path $IconPath)) {
    throw "Icon file was not found: $IconPath"
}

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($lnk)
$shortcut.TargetPath = $powershellExe
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$launcher`""
$shortcut.WorkingDirectory = $scriptDir
$shortcut.Description = 'One-click launcher for the DeepSeek Harness Web GUI'
if ($IconPath -ne '') {
    $shortcut.IconLocation = "$IconPath,0"
}
$shortcut.Save()

Write-Host "Created shortcut: $lnk"
if ($IconPath -eq '') {
    Write-Host 'Tip: pass -IconPath <file.ico> to give the shortcut a custom icon.'
}
