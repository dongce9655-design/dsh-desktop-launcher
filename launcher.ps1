# dsh-desktop-launcher - launcher.ps1
# One-click launcher for the DeepSeek Harness Web GUI (original implementation).
#
# Behavior:
#   * If the GUI is already running at $Url, just open it in the default browser.
#   * Otherwise start `dsh web` as a hidden background process and poll until
#     the GUI answers, then open the browser.
#   * `-Stop` kills the running dsh web process instead of starting anything.
[CmdletBinding()]
param(
    [string]$Url = 'http://127.0.0.1:3080',
    [string]$DshCommand = 'dsh',
    [int]$TimeoutSeconds = 60,
    [switch]$Stop,
    [switch]$NoOpen
)

$ErrorActionPreference = 'Stop'

function Test-Url {
    param([string]$Address)
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Address -TimeoutSec 2
        return ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500)
    } catch {
        return $false
    }
}

function Stop-DshWeb {
    # Derive the listen port from the configured URL so -Stop matches -Url.
    $port = 3080
    try {
        $parsed = [uri]$Url
        if ($parsed.Port -gt 0) { $port = $parsed.Port }
    } catch { }
    $listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($null -eq $listener) {
        Write-Host "dsh web is not running on port $port."
        return
    }
    $pidToStop = $listener.OwningProcess
    Stop-Process -Id $pidToStop -Force -ErrorAction SilentlyContinue
    Write-Host "Stopped dsh web (PID $pidToStop)."
}

# -Stop mode: shut down an already running instance.
if ($Stop) {
    Stop-DshWeb
    return
}

# Already running? Then there is nothing to start.
if (Test-Url -Address $Url) {
    if (-not $NoOpen) { Start-Process $Url }
    Write-Host "DeepSeek Harness is already running at $Url"
    return
}

# Resolve the dsh command. Prefer executable shims (.cmd/.exe/.bat/.com) over
# PowerShell scripts so the ExecutionPolicy can never block the launch.
$candidates = @(Get-Command $DshCommand -ErrorAction SilentlyContinue)
$command = $candidates | Where-Object {
    $_.CommandType -eq 'Application' -and $_.Source -match '\.(cmd|exe|bat|com)$'
} | Select-Object -First 1
if ($null -eq $command) {
    $command = $candidates | Where-Object { $_.CommandType -eq 'Application' } | Select-Object -First 1
}
if ($null -eq $command) {
    $command = $candidates | Select-Object -First 1
}
if ($null -eq $command) {
    Write-Error "dsh command '$DshCommand' was not found. Install DeepSeek Harness, or pass -DshCommand with an absolute path."
    exit 1
}

Write-Host "Starting 'dsh web' (hidden) via $($command.Source) ..."
Start-Process -FilePath $command.Source -ArgumentList 'web' -WindowStyle Hidden

# Poll until the GUI responds (or the timeout expires), then open the browser.
$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
while ((Get-Date) -lt $deadline) {
    if (Test-Url -Address $Url) {
        if (-not $NoOpen) { Start-Process $Url }
        Write-Host "DeepSeek Harness is ready at $Url"
        return
    }
    Start-Sleep -Milliseconds 500
}

Write-Error "Timed out after $TimeoutSeconds seconds waiting for $Url"
exit 2
