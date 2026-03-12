@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
::  Development Environment Bootstrap Script
::  Safe to re-run (idempotent). Installs tools, configs, and providers.
:: ============================================================================

:: ANSI color codes (Windows 10+ terminals support these)
:: Generate ESC character via prompt trick
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RED=%ESC%[31m"
set "CYAN=%ESC%[36m"
set "BOLD=%ESC%[1m"
set "RESET=%ESC%[0m"

set "SCRIPTDIR=%~dp0"
:: Remove trailing backslash
if "%SCRIPTDIR:~-1%"=="\" set "SCRIPTDIR=%SCRIPTDIR:~0,-1%"

set "ERRORS=0"
set "INSTALLED="
set "SKIPPED="
set "FAILED="

:: ============================================================================
::  Section 1: Prerequisites
:: ============================================================================
echo.
echo %BOLD%%CYAN%========================================%RESET%
echo %BOLD%%CYAN%  Development Environment Bootstrap%RESET%
echo %BOLD%%CYAN%========================================%RESET%
echo.

:: --- Check admin ---
echo %BOLD%[1/9] Checking prerequisites...%RESET%
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%  WARNING: Not running as Administrator.%RESET%
    echo %YELLOW%  Some installations may fail. Consider re-running as admin.%RESET%
    echo.
) else (
    echo %GREEN%  Running as Administrator.%RESET%
)

:: --- Check winget ---
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%  ERROR: winget not found. Please install App Installer from the Microsoft Store.%RESET%
    echo %RED%  https://aka.ms/getwinget%RESET%
    exit /b 1
) else (
    echo %GREEN%  winget found.%RESET%
)
echo.

:: ============================================================================
::  Section 2: Install core CLI tools via winget
:: ============================================================================
echo %BOLD%[2/9] Installing core CLI tools via winget...%RESET%
echo.

call :winget_install "Neovim"            "Neovim.Neovim"
call :winget_install "Git"               "Git.Git"
call :winget_install "Node.js LTS"       "OpenJS.NodeJS.LTS"
call :winget_install "ripgrep"           "BurntSushi.ripgrep.MSVC"
call :winget_install "fd"                "sharkdp.fd"
call :winget_install "fzf"               "junegunn.fzf"
call :winget_install "Starship"          "Starship.Starship"
call :winget_install "eza"               "eza-community.eza"
call :winget_install "bat"               "sharkdp.bat"
call :winget_install "zoxide"            "ajeetdsouza.zoxide"
call :winget_install "Rustup"            "Rustlang.Rustup"
call :winget_install "uv"                "astral-sh.uv"
call :winget_install "Chocolatey"        "Chocolatey.Chocolatey"
echo.

:: ============================================================================
::  Section 3: Install PowerShell module (PSFzf)
:: ============================================================================
echo %BOLD%[3/9] Installing PowerShell module PSFzf...%RESET%

where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%  pwsh not found, trying powershell.exe...%RESET%
    powershell -NoProfile -Command "if (Get-Module -ListAvailable -Name PSFzf) { Write-Host 'PSFzf already installed' } else { Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber; Write-Host 'PSFzf installed' }"
) else (
    pwsh -NoProfile -Command "if (Get-Module -ListAvailable -Name PSFzf) { Write-Host 'PSFzf already installed' } else { Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber; Write-Host 'PSFzf installed' }"
)
if %errorlevel% neq 0 (
    echo %RED%  Failed to install PSFzf.%RESET%
    set "FAILED=!FAILED! PSFzf"
    set /a ERRORS+=1
) else (
    echo %GREEN%  PSFzf OK.%RESET%
)
echo.

:: ============================================================================
::  Section 4: Set up Python environment
:: ============================================================================
echo %BOLD%[4/9] Setting up Python environment...%RESET%

where uv >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%  uv not found in PATH. You may need to restart your terminal after winget install.%RESET%
    echo %YELLOW%  Skipping Python setup.%RESET%
    set "FAILED=!FAILED! Python-setup"
    set /a ERRORS+=1
) else (
    echo   Installing Python 3.12 via uv...
    uv python install 3.12
    if %errorlevel% neq 0 (
        echo %RED%  Failed to install Python 3.12.%RESET%
        set "FAILED=!FAILED! Python-3.12"
        set /a ERRORS+=1
    ) else (
        echo %GREEN%  Python 3.12 OK.%RESET%
    )

    if not exist "%LOCALAPPDATA%\python-global\Scripts\python.exe" (
        echo   Creating global venv at %LOCALAPPDATA%\python-global...
        uv venv "%LOCALAPPDATA%\python-global" --python 3.12
        if %errorlevel% neq 0 (
            echo %RED%  Failed to create global venv.%RESET%
            set "FAILED=!FAILED! python-global-venv"
            set /a ERRORS+=1
        ) else (
            echo %GREEN%  Global venv created.%RESET%
        )
    ) else (
        echo %GREEN%  Global venv already exists.%RESET%
    )

    if exist "%LOCALAPPDATA%\python-global\Scripts\python.exe" (
        echo   Installing pynvim...
        uv pip install --python "%LOCALAPPDATA%\python-global\Scripts\python.exe" pynvim
        if %errorlevel% neq 0 (
            echo %RED%  Failed to install pynvim.%RESET%
            set "FAILED=!FAILED! pynvim"
            set /a ERRORS+=1
        ) else (
            echo %GREEN%  pynvim OK.%RESET%
        )
    )
)
echo.

:: ============================================================================
::  Section 5: Install Node neovim provider
:: ============================================================================
echo %BOLD%[5/9] Installing Node neovim provider...%RESET%

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%  npm not found in PATH. You may need to restart your terminal after winget install.%RESET%
    echo %YELLOW%  Skipping neovim node provider.%RESET%
    set "FAILED=!FAILED! node-neovim"
    set /a ERRORS+=1
) else (
    npm list -g neovim >nul 2>&1
    if %errorlevel% neq 0 (
        echo   Installing neovim npm package globally...
        npm install -g neovim
        if %errorlevel% neq 0 (
            echo %RED%  Failed to install neovim npm package.%RESET%
            set "FAILED=!FAILED! node-neovim"
            set /a ERRORS+=1
        ) else (
            echo %GREEN%  neovim npm package installed.%RESET%
        )
    ) else (
        echo %GREEN%  neovim npm package already installed.%RESET%
    )
)
echo.

:: ============================================================================
::  Section 6: Install Nerd Font
:: ============================================================================
echo %BOLD%[6/9] Installing JetBrainsMono Nerd Font...%RESET%

:: Check if the font is already installed by looking in the fonts directory
dir "%LOCALAPPDATA%\Microsoft\Windows\Fonts\JetBrainsMonoNerdFont*" >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%  JetBrainsMono Nerd Font already installed (user fonts).%RESET%
) else (
    dir "%WINDIR%\Fonts\JetBrainsMonoNerdFont*" >nul 2>&1
    if %errorlevel% equ 0 (
        echo %GREEN%  JetBrainsMono Nerd Font already installed (system fonts).%RESET%
    ) else (
        echo   Installing via winget...
        winget install --id "DEVCOM.JetBrainsMonoNerdFont" --accept-package-agreements --accept-source-agreements
        if %errorlevel% neq 0 (
            echo %YELLOW%  Font install may have failed or requires manual install.%RESET%
            set "FAILED=!FAILED! NerdFont"
            set /a ERRORS+=1
        ) else (
            echo %GREEN%  JetBrainsMono Nerd Font installed.%RESET%
        )
    )
)
echo.

:: ============================================================================
::  Section 7: Copy config files
:: ============================================================================
echo %BOLD%[7/9] Setting up config files...%RESET%

:: --- PowerShell profile ---
set "PS_PROFILE_DIR=%USERPROFILE%\Documents\PowerShell"
set "PS_PROFILE=%PS_PROFILE_DIR%\Microsoft.PowerShell_profile.ps1"
set "PS_TEMPLATE=%SCRIPTDIR%\profile.ps1.template"

if exist "%PS_TEMPLATE%" (
    if not exist "%PS_PROFILE_DIR%" (
        echo   Creating directory: %PS_PROFILE_DIR%
        mkdir "%PS_PROFILE_DIR%" >nul 2>&1
    )
    call :copy_config "%PS_TEMPLATE%" "%PS_PROFILE%" "PowerShell profile"
) else (
    echo %YELLOW%  Template not found: %PS_TEMPLATE%%RESET%
)

:: --- Starship config ---
set "STARSHIP_DIR=%USERPROFILE%\.config"
set "STARSHIP_DEST=%STARSHIP_DIR%\starship.toml"
set "STARSHIP_TEMPLATE=%SCRIPTDIR%\starship.toml.template"

if exist "%STARSHIP_TEMPLATE%" (
    if not exist "%STARSHIP_DIR%" (
        echo   Creating directory: %STARSHIP_DIR%
        mkdir "%STARSHIP_DIR%" >nul 2>&1
    )
    call :copy_config "%STARSHIP_TEMPLATE%" "%STARSHIP_DEST%" "Starship config"
) else (
    echo %YELLOW%  Template not found: %STARSHIP_TEMPLATE%%RESET%
)

:: --- tmux config ---
set "TMUX_DEST=%USERPROFILE%\.tmux.conf"
set "TMUX_TEMPLATE=%SCRIPTDIR%\tmux.windows.conf.template"

if exist "%TMUX_TEMPLATE%" (
    call :copy_config "%TMUX_TEMPLATE%" "%TMUX_DEST%" "tmux config"
) else (
    echo %YELLOW%  Template not found: %TMUX_TEMPLATE%%RESET%
)
echo.

:: ============================================================================
::  Section 8: psmux plugins
:: ============================================================================
echo %BOLD%[8/9] Checking psmux setup...%RESET%

where psmux >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%  psmux not found in PATH. Skipping psmux plugin setup.%RESET%
) else (
    set "PSMUX_PLUGIN_DIR=%USERPROFILE%\.psmux\plugins"
    if not exist "!PSMUX_PLUGIN_DIR!" (
        echo   Creating psmux plugins directory: !PSMUX_PLUGIN_DIR!
        mkdir "!PSMUX_PLUGIN_DIR!" >nul 2>&1
    )
    echo %GREEN%  psmux plugins directory ready at !PSMUX_PLUGIN_DIR!%RESET%
    echo   You may need to install PPM plugins manually via psmux.
)
echo.

:: ============================================================================
::  Section 9: Summary
:: ============================================================================
echo %BOLD%%CYAN%========================================%RESET%
echo %BOLD%%CYAN%  Setup Complete!%RESET%
echo %BOLD%%CYAN%========================================%RESET%
echo.

if defined INSTALLED (
    echo %GREEN%  Installed:%RESET%!INSTALLED!
)
if defined SKIPPED (
    echo %YELLOW%  Already present:%RESET%!SKIPPED!
)
if %ERRORS% gtr 0 (
    echo %RED%  Failed (%ERRORS%):%RESET%!FAILED!
    echo.
)

echo %BOLD%  Manual steps remaining:%RESET%
echo.
echo   1. %CYAN%Set your terminal font%RESET% to %BOLD%JetBrainsMono Nerd Font Mono%RESET%
echo      (Windows Terminal: Settings ^> Profiles ^> Defaults ^> Appearance ^> Font face)
echo.
echo   2. %CYAN%Restart your terminal%RESET% so new PATH entries take effect.
echo.
echo   3. %CYAN%Launch Neovim%RESET% and let it auto-install plugins, LSP servers,
echo      and formatters on first launch. This may take a few minutes.
echo.
echo   4. Run %BOLD%:Copilot auth%RESET% inside Neovim to authenticate GitHub Copilot.
echo.

endlocal
exit /b 0

:: ============================================================================
::  Helper: winget_install <display_name> <package_id>
:: ============================================================================
:winget_install
set "DISPLAY_NAME=%~1"
set "PKG_ID=%~2"

:: Use winget list to check if already installed
winget list --id "%PKG_ID%" --exact >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%  [SKIP] %DISPLAY_NAME% already installed.%RESET%
    set "SKIPPED=!SKIPPED! %DISPLAY_NAME%"
    goto :eof
)

echo   Installing %DISPLAY_NAME% (%PKG_ID%)...
winget install --accept-package-agreements --accept-source-agreements -e --id "%PKG_ID%"
if %errorlevel% neq 0 (
    echo %RED%  [FAIL] %DISPLAY_NAME% installation failed.%RESET%
    set "FAILED=!FAILED! %DISPLAY_NAME%"
    set /a ERRORS+=1
) else (
    echo %GREEN%  [OK]   %DISPLAY_NAME% installed.%RESET%
    set "INSTALLED=!INSTALLED! %DISPLAY_NAME%"
)
goto :eof

:: ============================================================================
::  Helper: copy_config <source> <destination> <label>
::  Copies source to destination. If destination already exists and differs,
::  prompts the user.
:: ============================================================================
:copy_config
set "SRC=%~1"
set "DST=%~2"
set "LABEL=%~3"

if not exist "%DST%" (
    echo   Copying %LABEL%...
    copy /Y "%SRC%" "%DST%" >nul
    if %errorlevel% equ 0 (
        echo %GREEN%  [OK] %LABEL% installed to %DST%%RESET%
        set "INSTALLED=!INSTALLED! %LABEL%"
    ) else (
        echo %RED%  [FAIL] Could not copy %LABEL%.%RESET%
        set "FAILED=!FAILED! %LABEL%"
        set /a ERRORS+=1
    )
    goto :eof
)

:: Destination exists - compare files
fc /b "%SRC%" "%DST%" >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%  [SKIP] %LABEL% already up to date.%RESET%
    set "SKIPPED=!SKIPPED! %LABEL%"
    goto :eof
)

:: Files differ - ask user
echo %YELLOW%  %LABEL% already exists and differs from template.%RESET%
echo   Source:  %SRC%
echo   Target:  %DST%
set /p "OVERWRITE=  Overwrite? [y/N]: "
if /i "%OVERWRITE%"=="y" (
    copy /Y "%SRC%" "%DST%" >nul
    if %errorlevel% equ 0 (
        echo %GREEN%  [OK] %LABEL% updated.%RESET%
        set "INSTALLED=!INSTALLED! %LABEL%"
    ) else (
        echo %RED%  [FAIL] Could not copy %LABEL%.%RESET%
        set "FAILED=!FAILED! %LABEL%"
        set /a ERRORS+=1
    )
) else (
    echo   Skipped %LABEL%.
    set "SKIPPED=!SKIPPED! %LABEL%"
)
goto :eof
