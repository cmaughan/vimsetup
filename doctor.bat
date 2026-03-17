@echo off
setlocal EnableDelayedExpansion

:: ---------------------------------------------------------------------
::  doctor.bat -- Development Environment Health Check
::  Read-only diagnostic tool. Installs nothing, only reports.
:: ---------------------------------------------------------------------

:: ANSI color codes (requires Windows 10+)
:: Generate ESC character via prompt trick
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "YELLOW=%ESC%[33m"
set "CYAN=%ESC%[36m"
set "BOLD=%ESC%[1m"
set "DIM=%ESC%[90m"
set "RESET=%ESC%[0m"

:: Counters
set /a PASS=0
set /a WARN=0
set /a FAIL=0

:: Config directory (where this script lives)
set "CFGDIR=%~dp0"

echo.
echo %BOLD%%CYAN%==============================================================%RESET%
echo %BOLD%%CYAN%  Development Environment Health Check%RESET%
echo %BOLD%%CYAN%==============================================================%RESET%
echo   %DIM%Config dir: %CFGDIR%%RESET%
echo.

:: ---------------------------------------------------------------------
::  Section: Core Tools
:: ---------------------------------------------------------------------
echo %BOLD%-- Core Tools ------------------------------------------------------%RESET%
echo.

call :check_tool nvim       "nvim --version"       1  "winget install Neovim.Neovim"
call :check_tool git        "git --version"        1  "winget install Git.Git"
call :check_tool node       "node --version"       1  "winget install OpenJS.NodeJS.LTS"
call :check_tool npm        "npm --version"        1  "install node"
call :check_tool rg         "rg --version"         1  "winget install BurntSushi.ripgrep.MSVC"
call :check_tool fd         "fd --version"         1  "winget install sharkdp.fd"
call :check_tool fzf        "fzf --version"        1  "winget install junegunn.fzf"
call :check_tool starship   "starship --version"   1  "winget install Starship.Starship"
call :check_tool eza        "eza --version"        1  "winget install eza-community.eza"
call :check_tool bat        "bat --version"        1  "winget install sharkdp.bat"
call :check_tool zoxide     "zoxide --version"     1  "winget install ajeetdsouza.zoxide"
call :check_tool uv         "uv --version"         1  "winget install astral-sh.uv"
call :check_tool rustup     "rustup --version"     1  "winget install Rustlang.Rustup"
call :check_tool cargo      "cargo --version"      1  "install rustup"
call :check_tool cmake      "cmake --version"      1  "winget install Kitware.CMake"
call :check_tool psmux      "psmux --version"      1  "cargo install psmux"

echo.

:: ---------------------------------------------------------------------
::  Section: Python Environment
:: ---------------------------------------------------------------------
echo %BOLD%-- Python Environment ----------------------------------------------%RESET%
echo.

:: Check uv
where uv >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[OK]%RESET%      uv is installed
    set /a PASS+=1 >nul
) else (
    echo   %RED%[MISSING]%RESET%  uv --install with: winget install astral-sh.uv
    set /a FAIL+=1 >nul
)

:: Check Python 3.12 via python-global
set "PYGLOBAL=%LOCALAPPDATA%\python-global\Scripts\python.exe"
if exist "!PYGLOBAL!" (
    for /f "tokens=*" %%v in ('"!PYGLOBAL!" --version 2^>^&1') do set "PYVER=%%v"
    echo   %GREEN%[OK]%RESET%      python-global: !PYVER!
    set /a PASS+=1 >nul
) else (
    :: Fallback: check uv python list for 3.12
    where uv >nul 2>&1
    if !errorlevel! equ 0 (
        set "PY312_FOUND="
        for /f "tokens=*" %%l in ('uv python list 2^>nul ^| findstr "3.12"') do set "PY312_FOUND=%%l"
        if defined PY312_FOUND (
            echo   %YELLOW%[WARN]%RESET%    Python 3.12 available via uv, but python-global not set up
            echo              %DIM%Expected: !PYGLOBAL!%RESET%
            set /a WARN+=1 >nul
        ) else (
            echo   %RED%[MISSING]%RESET%  Python 3.12 --run: uv python install 3.12
            set /a FAIL+=1 >nul
        )
    ) else (
        echo   %RED%[MISSING]%RESET%  Python 3.12 --install uv first, then: uv python install 3.12
        set /a FAIL+=1 >nul
    )
)

:: Check pynvim
if exist "!PYGLOBAL!" (
    "!PYGLOBAL!" -c "import pynvim; print(pynvim.__version__)" >"%TEMP%\_doctor_pynvim.txt" 2>nul
    if !errorlevel! equ 0 (
        set /p PYNVIMVER=<"%TEMP%\_doctor_pynvim.txt"
        echo   %GREEN%[OK]%RESET%      pynvim !PYNVIMVER!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  pynvim --install with: uv pip install --python "!PYGLOBAL!" pynvim
        set /a FAIL+=1 >nul
    )
    del "%TEMP%\_doctor_pynvim.txt" 2>nul
) else (
    echo   %YELLOW%[WARN]%RESET%    pynvim --cannot check ^(python-global not found^)
    set /a WARN+=1 >nul
)

:: Check neovim node provider
where npm >nul 2>&1
if !errorlevel! equ 0 (
    set "NODEVIMVER="
    for /f "tokens=*" %%v in ('npm list -g neovim 2^>nul ^| findstr "neovim@"') do set "NODEVIMVER=%%v"
    if defined NODEVIMVER (
        echo   %GREEN%[OK]%RESET%      neovim node provider: !NODEVIMVER!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  neovim node provider --install with: npm install -g neovim
        set /a FAIL+=1 >nul
    )
) else (
    echo   %YELLOW%[WARN]%RESET%    neovim node provider --cannot check ^(npm not found^)
    set /a WARN+=1 >nul
)

echo.

:: ---------------------------------------------------------------------
::  Section: Config Files
:: ---------------------------------------------------------------------
echo %BOLD%-- Config Files ----------------------------------------------------%RESET%
echo.

:: Resolve actual $PROFILE path from PowerShell (handles OneDrive-redirected Documents)
set "PS_PROFILE="
where pwsh >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=*" %%p in ('pwsh -NoProfile -Command "Write-Output $PROFILE"') do set "PS_PROFILE=%%p"
)
if not defined PS_PROFILE set "PS_PROFILE=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

call :check_config "PowerShell profile"  "!PS_PROFILE!"  "%CFGDIR%profile.ps1.template"
call :check_config "Starship config"     "%USERPROFILE%\.config\starship.toml"                                  "%CFGDIR%starship.toml.template"
call :check_config "Tmux config"         "%USERPROFILE%\.tmux.conf"                                             "%CFGDIR%tmux.windows.conf.template"

echo.

:: ---------------------------------------------------------------------
::  Section: Neovim Health
:: ---------------------------------------------------------------------
echo %BOLD%-- Neovim Health ---------------------------------------------------%RESET%
echo.

:: Check lazy.nvim
if exist "%LOCALAPPDATA%\nvim-data\lazy\lazy.nvim" (
    echo   %GREEN%[OK]%RESET%      lazy.nvim installed
    set /a PASS+=1 >nul
) else (
    echo   %RED%[MISSING]%RESET%  lazy.nvim --open nvim to bootstrap, or check config
    set /a FAIL+=1 >nul
)

:: Check Mason bin directory
if exist "%LOCALAPPDATA%\nvim-data\mason\bin" (
    echo   %GREEN%[OK]%RESET%      Mason tools directory exists
    set /a PASS+=1 >nul

    :: List installed Mason tools
    set "MASON_COUNT=0"
    for %%f in ("%LOCALAPPDATA%\nvim-data\mason\bin\*") do set /a MASON_COUNT+=1 >nul
    if !MASON_COUNT! gtr 0 (
        echo              %DIM%Installed Mason tools ^(!MASON_COUNT!^):%RESET%
        for %%f in ("%LOCALAPPDATA%\nvim-data\mason\bin\*") do (
            echo              %DIM%  - %%~nxf%RESET%
        )
    ) else (
        echo   %YELLOW%[WARN]%RESET%    Mason bin directory is empty --run :Mason in nvim
        set /a WARN+=1 >nul
    )
) else (
    echo   %RED%[MISSING]%RESET%  Mason tools directory --open nvim and run :Mason
    set /a FAIL+=1 >nul
)

echo.

:: ---------------------------------------------------------------------
::  Section: Font
:: ---------------------------------------------------------------------
echo %BOLD%-- Font ------------------------------------------------------------%RESET%
echo.

set "FONT_FOUND="
:: Check user fonts
if exist "%LOCALAPPDATA%\Microsoft\Windows\Fonts" (
    for %%f in ("%LOCALAPPDATA%\Microsoft\Windows\Fonts\JetBrains*Nerd*") do set "FONT_FOUND=%%~nxf"
)
:: Check system fonts
if not defined FONT_FOUND (
    if exist "%WINDIR%\Fonts" (
        for %%f in ("%WINDIR%\Fonts\JetBrains*Nerd*") do set "FONT_FOUND=%%~nxf"
    )
)

if defined FONT_FOUND (
    echo   %GREEN%[OK]%RESET%      JetBrainsMono Nerd Font installed
    set /a PASS+=1 >nul
) else (
    echo   %YELLOW%[WARN]%RESET%    JetBrainsMono Nerd Font not found
    echo              %DIM%Install from: https://www.nerdfonts.com/font-downloads%RESET%
    set /a WARN+=1 >nul
)

echo.

:: ---------------------------------------------------------------------
::  Section: PowerShell Modules
:: ---------------------------------------------------------------------
echo %BOLD%-- PowerShell Modules ----------------------------------------------%RESET%
echo.

where pwsh >nul 2>&1
if !errorlevel! equ 0 (
    pwsh -NoProfile -Command "if (Get-Module -ListAvailable PSFzf) { exit 0 } else { exit 1 }" >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=*" %%v in ('pwsh -NoProfile -Command "(Get-Module -ListAvailable PSFzf).Version.ToString()" 2^>nul') do set "PSFZFVER=%%v"
        echo   %GREEN%[OK]%RESET%      PSFzf module v!PSFZFVER!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  PSFzf module --install with: Install-Module PSFzf -Scope CurrentUser
        set /a FAIL+=1 >nul
    )
) else (
    echo   %YELLOW%[WARN]%RESET%    pwsh not found --cannot check PowerShell modules
    set /a WARN+=1 >nul
)

echo.

:: ---------------------------------------------------------------------
::  Summary
:: ---------------------------------------------------------------------
echo %BOLD%%CYAN%==============================================================%RESET%
set /a TOTAL=!PASS!+!WARN!+!FAIL!
echo   %GREEN%!PASS! passed%RESET%, %YELLOW%!WARN! warnings%RESET%, %RED%!FAIL! errors%RESET%  ^(%TOTAL% checks^)
echo %BOLD%%CYAN%==============================================================%RESET%
echo.

if !FAIL! gtr 0 (
    exit /b 1
) else (
    exit /b 0
)

:: ---------------------------------------------------------------------
::  Subroutines
:: ---------------------------------------------------------------------

:: :check_tool <name> <version_cmd> <version_line> <install_hint>
::   Checks if a tool is on PATH and shows its version.
:check_tool
    set "TOOL_NAME=%~1"
    set "VER_CMD=%~2"
    set "VER_LINE=%~3"
    set "INSTALL=%~4"

    where %TOOL_NAME% >nul 2>&1
    if !errorlevel! equ 0 (
        set "VER_OUTPUT="
        set "LINE_NUM=0"
        for /f "tokens=*" %%v in ('%VER_CMD% 2^>^&1') do (
            set /a LINE_NUM+=1 >nul
            if !LINE_NUM! equ %VER_LINE% set "VER_OUTPUT=%%v"
        )
        if defined VER_OUTPUT (
            echo   %GREEN%[OK]%RESET%      %TOOL_NAME% --!VER_OUTPUT!
        ) else (
            echo   %GREEN%[OK]%RESET%      %TOOL_NAME% --installed
        )
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  %TOOL_NAME% --install with: %INSTALL%
        set /a FAIL+=1 >nul
    )
    exit /b

:: :check_config <label> <actual_path> <template_path>
::   Checks if a config file exists and matches its template.
:check_config
    set "CFG_LABEL=%~1"
    set "CFG_PATH=%~2"
    set "TPL_PATH=%~3"

    if not exist "%TPL_PATH%" (
        echo   %YELLOW%[WARN]%RESET%    %CFG_LABEL% --template not found: %TPL_PATH%
        set /a WARN+=1 >nul
        exit /b
    )

    if exist "%CFG_PATH%" (
        fc "%CFG_PATH%" "%TPL_PATH%" >nul 2>&1
        if !errorlevel! equ 0 (
            echo   %GREEN%[OK]%RESET%      %CFG_LABEL% --matches template
            set /a PASS+=1 >nul
        ) else (
            echo   %YELLOW%[OUTDATED]%RESET% %CFG_LABEL% --differs from template
            echo              %DIM%Actual:   %CFG_PATH%%RESET%
            echo              %DIM%Template: %TPL_PATH%%RESET%
            set /a WARN+=1 >nul
        )
    ) else (
        echo   %RED%[MISSING]%RESET%  %CFG_LABEL%
        echo              %DIM%Expected: %CFG_PATH%%RESET%
        set /a FAIL+=1 >nul
    )
    exit /b
