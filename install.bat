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
if !errorlevel! neq 0 (
    echo %YELLOW%  WARNING: Not running as Administrator.%RESET%
    echo %YELLOW%  Some installations may fail. Consider re-running as admin.%RESET%
    echo.
) else (
    echo %GREEN%  Running as Administrator.%RESET%
)

:: --- Check winget ---
where winget >nul 2>&1
if !errorlevel! neq 0 (
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
call :winget_install "Graphviz"          "Graphviz.Graphviz"
call :winget_install "clang-uml"         "bkryza.clang-uml"
call :winget_install "CMake"             "Kitware.CMake"
call :winget_install "Ninja"             "Ninja-build.Ninja"
call :winget_install "Doxygen"           "DimitriVanHeesch.Doxygen"
call :winget_install "Quarto"            "Posit.Quarto"
call :winget_install "ccache"            "ccache.ccache"
call :winget_install "LLVM (clang-format)" "LLVM.LLVM"
call :winget_install "Chocolatey"        "Chocolatey.Chocolatey"
call :choco_install "PlantUML"          "plantuml"
echo.

:: ============================================================================
::  Section 3: Install PowerShell module (PSFzf)
:: ============================================================================
echo %BOLD%[3/9] Installing PowerShell module PSFzf...%RESET%

where pwsh >nul 2>&1
if !errorlevel! neq 0 (
    echo %YELLOW%  pwsh not found, trying powershell.exe...%RESET%
    powershell -NoProfile -Command "if (Get-Module -ListAvailable -Name PSFzf) { Write-Host 'PSFzf already installed' } else { Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber; Write-Host 'PSFzf installed' }"
) else (
    pwsh -NoProfile -Command "if (Get-Module -ListAvailable -Name PSFzf) { Write-Host 'PSFzf already installed' } else { Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber; Write-Host 'PSFzf installed' }"
)
if !errorlevel! neq 0 (
    echo %RED%  Failed to install PSFzf.%RESET%
    set "FAILED=!FAILED! PSFzf"
    set /a ERRORS+=1 >nul
) else (
    echo %GREEN%  PSFzf OK.%RESET%
)
echo.

:: ============================================================================
::  Section 4: Set up Python environment
:: ============================================================================
echo %BOLD%[4/9] Setting up Python environment...%RESET%

where uv >nul 2>&1
if !errorlevel! neq 0 (
    echo %YELLOW%  uv not found in PATH. Skipping Python setup.%RESET%
    set "FAILED=!FAILED! Python-setup"
    set /a ERRORS+=1 >nul
    goto :after_python
)
echo   Installing Python 3.12 via uv...
call uv python install 3.12
if !errorlevel! neq 0 (
    echo %RED%  Failed to install Python 3.12.%RESET%
    set "FAILED=!FAILED! Python-3.12"
    set /a ERRORS+=1 >nul
) else (
    echo %GREEN%  Python 3.12 OK.%RESET%
)
if not exist "%LOCALAPPDATA%\python-global\Scripts\python.exe" (
    echo   Creating global venv at %LOCALAPPDATA%\python-global...
    call uv venv "%LOCALAPPDATA%\python-global" --python 3.12
    if !errorlevel! neq 0 (
        echo %RED%  Failed to create global venv.%RESET%
        set "FAILED=!FAILED! python-global-venv"
        set /a ERRORS+=1 >nul
    ) else (
        echo %GREEN%  Global venv created.%RESET%
    )
) else (
    echo %GREEN%  Global venv already exists.%RESET%
)
if exist "%LOCALAPPDATA%\python-global\Scripts\python.exe" (
    echo   Installing pynvim and PyYAML...
    call uv pip install --python "%LOCALAPPDATA%\python-global\Scripts\python.exe" pynvim PyYAML
    if !errorlevel! neq 0 (
        echo %RED%  Failed to install Python packages.%RESET%
        set "FAILED=!FAILED! pynvim PyYAML"
        set /a ERRORS+=1 >nul
    ) else (
        echo %GREEN%  pynvim and PyYAML OK.%RESET%
    )
)
:: --- pre-commit ---
echo   Installing pre-commit...
call uv tool install pre-commit >nul 2>&1
if !errorlevel! neq 0 (
    echo %RED%  Failed to install pre-commit.%RESET%
    set "FAILED=!FAILED! pre-commit"
    set /a ERRORS+=1 >nul
) else (
    echo %GREEN%  pre-commit OK.%RESET%
)
:after_python
echo.

:: ============================================================================
::  Section 5: Install Node packages (neovim provider + AI CLI tools)
:: ============================================================================
echo %BOLD%[5/9] Installing Node packages...%RESET%

where npm >nul 2>&1
if !errorlevel! neq 0 (
    echo %YELLOW%  npm not found in PATH. Skipping neovim node provider.%RESET%
    set "FAILED=!FAILED! node-neovim"
    set /a ERRORS+=1 >nul >nul
    goto :after_npm
)
call npm list -g neovim >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  neovim npm package already installed.%RESET%
    goto :after_npm
)
echo   Installing neovim npm package globally...
call npm install -g neovim >nul 2>&1
if !errorlevel! neq 0 (
    echo %RED%  Failed to install neovim npm package.%RESET%
    set "FAILED=!FAILED! node-neovim"
    set /a ERRORS+=1 >nul >nul
) else (
    echo %GREEN%  neovim npm package installed.%RESET%
)
echo   Installing AI CLI tools...
call :npm_global_install "claude"  "@anthropic-ai/claude-code"
call :npm_global_install "codex"   "@openai/codex"
call :npm_global_install "gemini"  "@google/gemini-cli"
:after_npm
echo.

:: ============================================================================
::  Section 6: Install Nerd Font
:: ============================================================================
echo %BOLD%[6/9] Installing JetBrainsMono Nerd Font...%RESET%

:: Check if the font is already installed by looking in the fonts directory
dir "%LOCALAPPDATA%\Microsoft\Windows\Fonts\JetBrainsMonoNerdFont*" >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  JetBrainsMono Nerd Font already installed.%RESET%
    goto :after_font
)
dir "%WINDIR%\Fonts\JetBrainsMonoNerdFont*" >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  JetBrainsMono Nerd Font already installed.%RESET%
    goto :after_font
)
echo   Installing via winget...
winget install --id "DEVCOM.JetBrainsMonoNerdFont" --accept-package-agreements --accept-source-agreements
if !errorlevel! neq 0 (
    echo %YELLOW%  Font install may have failed or requires manual install.%RESET%
    set "FAILED=!FAILED! NerdFont"
    set /a ERRORS+=1 >nul
) else (
    echo %GREEN%  JetBrainsMono Nerd Font installed.%RESET%
)
:after_font
echo.

:: ============================================================================
::  Section 7: Copy config files
:: ============================================================================
echo %BOLD%[7/9] Setting up config files...%RESET%

:: --- PowerShell profile ---
:: Resolve actual $PROFILE path from PowerShell (handles OneDrive-redirected Documents)
set "PS_PROFILE="
where pwsh >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=*" %%p in ('pwsh -NoProfile -Command "Write-Output $PROFILE"') do set "PS_PROFILE=%%p"
)
if not defined PS_PROFILE set "PS_PROFILE=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
:: Extract directory from profile path
for %%d in ("!PS_PROFILE!") do set "PS_PROFILE_DIR=%%~dpd"
set "PS_TEMPLATE=%SCRIPTDIR%\profile.ps1.template"

if exist "%PS_TEMPLATE%" (
    if not exist "!PS_PROFILE_DIR!" (
        echo   Creating directory: !PS_PROFILE_DIR!
        mkdir "!PS_PROFILE_DIR!" >nul 2>&1
    )
    call :copy_config "%PS_TEMPLATE%" "!PS_PROFILE!" "PowerShell profile"
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
::  Section 8: Git aliases
:: ============================================================================
echo %BOLD%[8/9] Setting up Git aliases...%RESET%

git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit"
echo %GREEN%  [OK] git lol%RESET%

git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
echo %GREEN%  [OK] git lola%RESET%
echo.

:: ============================================================================
::  Section 9: psmux plugins
:: ============================================================================
echo %BOLD%[9/9] Checking psmux setup...%RESET%

where psmux >nul 2>&1
if !errorlevel! neq 0 (
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
::  Summary
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
if !ERRORS! gtr 0 (
    echo %RED%  Failed ^(!ERRORS!^):%RESET%!FAILED!
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
echo   4. In each git repo with a %BOLD%.pre-commit-config.yaml%RESET%, run: %BOLD%pre-commit install%RESET%
echo.
echo   5. Run %BOLD%:Copilot auth%RESET% inside Neovim to authenticate GitHub Copilot.
echo.

endlocal
exit /b 0

:: ============================================================================
::  Helper: npm_global_install <cmd> <package>
:: ============================================================================
:npm_global_install
set "_NPMCMD=%~1"
set "_NPMPKG=%~2"
where !_NPMCMD! >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  [SKIP] !_NPMCMD! already installed.%RESET%
    set "SKIPPED=!SKIPPED! !_NPMCMD!"
    goto :eof
)
echo   Installing !_NPMPKG!...
call npm install -g "!_NPMPKG!" >nul 2>&1
if !errorlevel! neq 0 (
    echo %RED%  [FAIL] !_NPMCMD! installation failed.%RESET%
    set "FAILED=!FAILED! !_NPMCMD!"
    set /a ERRORS+=1 >nul
) else (
    echo %GREEN%  [OK]   !_NPMCMD! installed.%RESET%
    set "INSTALLED=!INSTALLED! !_NPMCMD!"
)
goto :eof

:: ============================================================================
::  Helper: winget_install <display_name> <package_id>
:: ============================================================================
:winget_install
set "DISPLAY_NAME=%~1"
set "PKG_ID=%~2"

:: Check via winget list first, then fall back to PATH check
winget list --id "%PKG_ID%" --exact >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  [SKIP] %DISPLAY_NAME% already installed.%RESET%
    set "SKIPPED=!SKIPPED! %DISPLAY_NAME%"
    goto :eof
)
:: Also skip if the tool is already on PATH (may have been installed outside winget)
set "_CMD="
if /i "%PKG_ID%"=="Neovim.Neovim" set "_CMD=nvim"
if /i "%PKG_ID%"=="Git.Git" set "_CMD=git"
if /i "%PKG_ID%"=="OpenJS.NodeJS.LTS" set "_CMD=node"
if /i "%PKG_ID%"=="BurntSushi.ripgrep.MSVC" set "_CMD=rg"
if /i "%PKG_ID%"=="sharkdp.fd" set "_CMD=fd"
if /i "%PKG_ID%"=="junegunn.fzf" set "_CMD=fzf"
if /i "%PKG_ID%"=="Starship.Starship" set "_CMD=starship"
if /i "%PKG_ID%"=="eza-community.eza" set "_CMD=eza"
if /i "%PKG_ID%"=="sharkdp.bat" set "_CMD=bat"
if /i "%PKG_ID%"=="ajeetdsouza.zoxide" set "_CMD=zoxide"
if /i "%PKG_ID%"=="Rustlang.Rustup" set "_CMD=rustup"
if /i "%PKG_ID%"=="astral-sh.uv" set "_CMD=uv"
if /i "%PKG_ID%"=="Graphviz.Graphviz" set "_CMD=dot"
if /i "%PKG_ID%"=="bkryza.clang-uml" set "_CMD=clang-uml"
if /i "%PKG_ID%"=="Kitware.CMake" set "_CMD=cmake"
if /i "%PKG_ID%"=="Ninja-build.Ninja" set "_CMD=ninja"
if /i "%PKG_ID%"=="DimitriVanHeesch.Doxygen" set "_CMD=doxygen"
if /i "%PKG_ID%"=="Posit.Quarto" set "_CMD=quarto"
if /i "%PKG_ID%"=="LLVM.LLVM" set "_CMD=clang-format"
if /i "%PKG_ID%"=="ccache.ccache" set "_CMD=ccache"
if defined _CMD (
    where !_CMD! >nul 2>&1
    if !errorlevel! equ 0 (
        echo %GREEN%  [SKIP] %DISPLAY_NAME% already installed.%RESET%
        set "SKIPPED=!SKIPPED! %DISPLAY_NAME%"
        goto :eof
    )
)

echo   Installing %DISPLAY_NAME% (%PKG_ID%)...
winget install --accept-package-agreements --accept-source-agreements -e --id "%PKG_ID%"
if !errorlevel! neq 0 (
    echo %RED%  [FAIL] %DISPLAY_NAME% installation failed.%RESET%
    set "FAILED=!FAILED! %DISPLAY_NAME%"
    set /a ERRORS+=1 >nul
) else (
    echo %GREEN%  [OK]   %DISPLAY_NAME% installed.%RESET%
    set "INSTALLED=!INSTALLED! %DISPLAY_NAME%"
)
goto :eof

:: ============================================================================
::  Helper: choco_install <display_name> <package_name>
:: ============================================================================
:choco_install
set "DISPLAY_NAME=%~1"
set "PKG_NAME=%~2"

where %PKG_NAME% >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  [SKIP] %DISPLAY_NAME% already installed.%RESET%
    set "SKIPPED=!SKIPPED! %DISPLAY_NAME%"
    goto :eof
)

where choco >nul 2>&1
if !errorlevel! neq 0 (
    echo %RED%  [FAIL] %DISPLAY_NAME%: Chocolatey not found on PATH. Restart shell after winget install.%RESET%
    set "FAILED=!FAILED! %DISPLAY_NAME%"
    set /a ERRORS+=1 >nul
    goto :eof
)

echo   Installing %DISPLAY_NAME% via Chocolatey (%PKG_NAME%)...
choco install %PKG_NAME% -y
if !errorlevel! neq 0 (
    echo %RED%  [FAIL] %DISPLAY_NAME% installation failed.%RESET%
    set "FAILED=!FAILED! %DISPLAY_NAME%"
    set /a ERRORS+=1 >nul
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

if not exist "!DST!" (
    echo   Copying %LABEL%...
    copy /Y "!SRC!" "!DST!"
    if exist "!DST!" (
        echo %GREEN%  [OK] %LABEL% installed to !DST!%RESET%
        set "INSTALLED=!INSTALLED! %LABEL%"
    ) else (
        echo %RED%  [FAIL] Could not copy %LABEL%.%RESET%
        set "FAILED=!FAILED! %LABEL%"
        set /a ERRORS+=1 >nul
    )
    goto :eof
)

:: Destination exists - compare files
fc "!SRC!" "!DST!" >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%  [SKIP] %LABEL% already up to date.%RESET%
    set "SKIPPED=!SKIPPED! %LABEL%"
    goto :eof
)

:: Files differ - back up and overwrite
echo %YELLOW%  %LABEL% differs from template. Updating...%RESET%
copy /Y "!DST!" "!DST!.bak" >nul 2>&1
if exist "!DST!.bak" echo   Backed up to !DST!.bak
copy /Y "!SRC!" "!DST!"
if !errorlevel! equ 0 (
    echo %GREEN%  [OK] %LABEL% updated.%RESET%
    set "INSTALLED=!INSTALLED! %LABEL%"
) else (
    echo %RED%  [FAIL] Could not copy %LABEL%.%RESET%
    set "FAILED=!FAILED! %LABEL%"
    set /a ERRORS+=1 >nul
)
goto :eof
