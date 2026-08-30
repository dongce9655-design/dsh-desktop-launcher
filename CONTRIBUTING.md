# Contributing

Thanks for your interest in contributing to dsh-desktop-launcher!

## Development

- PowerShell 5.1+ / 7+ on Windows.
- Run the syntax check before committing:

```powershell
powershell -NoProfile -Command "$t=$null;$e=$null;Get-ChildItem -Filter *.ps1 | ForEach-Object {[System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$t,[ref]$e)|Out-Null;if($e.Count){$e|ForEach-Object{Write-Error $_.Message}}};Write-Host 'OK'"
```

## Guidelines

- Keep the launcher zero-dependency: no external modules, only built-in PowerShell / .NET.
- Scripts must stay ASCII-only in code; non-ASCII belongs in the README (PowerShell 5.1 decodes BOM-less files with the ANSI codepage).
- Keep Windows PowerShell 5.1 compatibility (avoid PS7-only syntax).
- If you change behavior, update the parameter table and FAQ in `README.md` and `README.en.md`.

## Commit & PR

1. Create a feature branch: `git checkout -b feat/my-change`
2. Commit with a clear message.
3. Push and open a pull request. CI validates script syntax automatically.
