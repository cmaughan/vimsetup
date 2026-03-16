@echo off
setlocal

set "IN_CODEX=1"
echo [codex] Launching PowerShell with IN_CODEX=1.

where pwsh >nul 2>&1
if not errorlevel 1 (
    pwsh -NoLogo
    exit /b %errorlevel%
)

echo [codex] pwsh not found, falling back to Windows PowerShell.
powershell -NoLogo
