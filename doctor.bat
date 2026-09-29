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
set "MIN_CMAKE_VERSION=4.0.0"

:: Config directory (where this script lives)
set "CFGDIR=%~dp0"

echo.
echo %BOLD%%CYAN%==============================================================%RESET%
echo %BOLD%%CYAN%  Development Environment Health Check%RESET%
echo %BOLD%%CYAN%==============================================================%RESET%
echo   %DIM%Config dir: %CFGDIR%%RESET%
echo.

call :prepend_path_if_exists "%ProgramFiles%\OpenSCAD (Nightly)"
call :prepend_path_if_exists "%ProgramFiles%\clang-uml\bin"
call :prepend_path_if_exists "%ProgramFiles%\Graphviz\bin"
call :prepend_path_if_exists "%ProgramFiles%\CMake\bin"

:: Prefer the directories used by the official AI CLI installers.
set "CODEX_NATIVE_BIN=%LOCALAPPDATA%\Programs\OpenAI\Codex\bin"
if defined CODEX_INSTALL_DIR set "CODEX_NATIVE_BIN=%CODEX_INSTALL_DIR%"
set "GROK_NATIVE_BIN=%USERPROFILE%\.grok\bin"
if defined GROK_BIN_DIR set "GROK_NATIVE_BIN=%GROK_BIN_DIR%"
set "PATH=%CODEX_NATIVE_BIN%;%GROK_NATIVE_BIN%;%LOCALAPPDATA%\agy\bin;%USERPROFILE%\.local\bin;%PATH%"

:: ---------------------------------------------------------------------
::  Section: Core Tools
:: ---------------------------------------------------------------------
echo %BOLD%-- Core Tools ------------------------------------------------------%RESET%
echo.

call :check_tool winget     "winget --version"     1  "App Installer from https://aka.ms/getwinget"
call :check_tool nvim       "nvim --version"       1  "winget install Neovim.Neovim"
call :check_tool git        "git --version"        1  "winget install Git.Git"
call :check_tool gh         "gh --version"         1  "winget install GitHub.cli"
call :check_tool pwsh       "pwsh --version"       1  "winget install Microsoft.PowerShell"
call :check_tool code       "code --version"       1  "winget install Microsoft.VisualStudioCode"
call :check_tool cursor     "cursor --version"     1  "winget install Anysphere.Cursor"
call :check_tool node       "node --version"       1  "winget install OpenJS.NodeJS.LTS"
call :check_tool npm        "npm --version"        1  "install node"
call :check_tool 7z         "7z i"                 2  "winget install 7zip.7zip"
call :check_tool rg         "rg --version"         1  "winget install BurntSushi.ripgrep.MSVC"
call :check_tool fd         "fd --version"         1  "winget install sharkdp.fd"
call :check_tool fzf        "fzf --version"        1  "winget install junegunn.fzf"
call :check_tool starship   "starship --version"   1  "winget install Starship.Starship"
call :check_tool eza        "eza --version"        1  "winget install eza-community.eza"
call :check_tool bat        "bat --version"        1  "winget install sharkdp.bat"
call :check_tool btop       "btop --version"       1  "winget install aristocratos.btop4win"
call :check_tool hexyl      "hexyl --version"      1  "winget install sharkdp.hexyl"
call :check_tool zoxide     "zoxide --version"     1  "winget install ajeetdsouza.zoxide"
call :check_tool uv         "uv --version"         1  "winget install astral-sh.uv"
call :check_tool rustup     "rustup --version"     1  "winget install Rustlang.Rustup"
call :check_tool cargo      "cargo --version"      1  "install rustup"
call :check_tool_min_version cmake "cmake --version" 1 "%MIN_CMAKE_VERSION%" "winget upgrade Kitware.CMake"
call :check_tool ninja      "ninja --version"      1  "winget install Ninja-build.Ninja"
call :check_tool doxygen    "doxygen --version"    1  "winget install DimitriVanHeesch.Doxygen"
call :check_tool psmux      "psmux --version"      1  "cargo install psmux"
call :check_tool dot        "dot -V"               1  "winget install Graphviz.Graphviz"
call :check_tool clang-uml  "clang-uml --version"  1  "winget install bkryza.clang-uml"
call :check_tool openscad   "openscad --version"   1  "winget install OpenSCAD.OpenSCAD.Nightly"
call :check_tool plantuml   "plantuml -version"    1  "choco install plantuml"
call :check_tool pre-commit "pre-commit --version" 1  "uv tool install pre-commit"
call :check_tool clang-format "clang-format --version" 1  "winget install LLVM.LLVM"
call :check_tool quarto     "quarto --version"     1  "winget install Posit.Quarto"
call :check_tool ccache     "ccache --version"     1  "winget install Ccache.Ccache"
call :check_tool vulkaninfo "vulkaninfo --version" 1  "winget install KhronosGroup.VulkanSDK"
call :check_tool glslc      "glslc --version"      1  "winget install KhronosGroup.VulkanSDK"
call :check_vulkan_sdk_env
call :check_tool ffmpeg     "ffmpeg -version"      1  "winget install Gyan.FFmpeg"
call :check_tool choco      "choco --version"      1  "winget install Chocolatey.Chocolatey"
call :check_website_cli "claude" "%USERPROFILE%\.local\bin\claude.exe" "PowerShell: irm https://claude.ai/install.ps1 | iex"
call :check_website_cli "codex" "%CODEX_NATIVE_BIN%\codex.exe" "PowerShell: irm https://chatgpt.com/codex/install.ps1 | iex"
call :check_website_cli "agy" "%LOCALAPPDATA%\agy\bin\agy.exe" "PowerShell: irm https://antigravity.google/cli/install.ps1 | iex"
call :check_website_cli "grok" "%GROK_NATIVE_BIN%\grok.exe" "PowerShell: irm https://x.ai/cli/install.ps1 | iex"
call :check_tool gemini     "gemini --version"     1  "npm install -g @google/gemini-cli"

call :check_winget_package "Codex App"             "9PLM9XGG6VKS"                  "winget install --source msstore --id 9PLM9XGG6VKS"
call :check_winget_package "Claude App"            "Anthropic.Claude"              "winget install Anthropic.Claude"
call :check_winget_package "Google Antigravity"    "Google.Antigravity"            "winget install Google.Antigravity"
call :check_command_path_contains "OpenSCAD Nightly path" "openscad" "Nightly" "winget install OpenSCAD.OpenSCAD.Nightly"

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

:: Check installed Python, not uv's catalog of downloadable versions.
where uv >nul 2>&1
if !errorlevel! equ 0 (
    uv python list --only-installed 2>nul | findstr /b /c:"cpython-3.12." >nul
    if !errorlevel! equ 0 (
        echo   %GREEN%[OK]%RESET%      Python 3.12 installed via uv
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  Python 3.12 --run: uv python install 3.12
        set /a FAIL+=1 >nul
    )
)

:: The installer creates this venv separately from the managed Python install.
set "PYGLOBAL=%LOCALAPPDATA%\python-global\Scripts\python.exe"
if exist "!PYGLOBAL!" (
    "!PYGLOBAL!" -c "import sys; sys.exit(0 if sys.version_info[:2] == (3, 12) else 1)" >nul 2>&1
    if !errorlevel! equ 0 (
        echo   %GREEN%[OK]%RESET%      python-global uses Python 3.12
        set /a PASS+=1 >nul
    ) else (
        echo   %YELLOW%[OUTDATED]%RESET% python-global is not using Python 3.12
        set /a WARN+=1 >nul
    )
) else (
    echo   %RED%[MISSING]%RESET%  python-global --run install.bat to create !PYGLOBAL!
    set /a FAIL+=1 >nul
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

    "!PYGLOBAL!" -c "import yaml; print(yaml.__version__)" >"%TEMP%\_doctor_pyyaml.txt" 2>nul
    if !errorlevel! equ 0 (
        set /p PYYAMLVER=<"%TEMP%\_doctor_pyyaml.txt"
        echo   %GREEN%[OK]%RESET%      PyYAML !PYYAMLVER!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  PyYAML --install with: uv pip install --python "!PYGLOBAL!" PyYAML
        set /a FAIL+=1 >nul
    )
    del "%TEMP%\_doctor_pyyaml.txt" 2>nul
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
::  Section: Git Aliases
:: ---------------------------------------------------------------------
echo %BOLD%-- Git Aliases -----------------------------------------------------%RESET%
echo.

call :check_git_alias "lol"  "log --graph --decorate --pretty=oneline --abbrev-commit"
call :check_git_alias "lola" "log --graph --decorate --pretty=oneline --abbrev-commit --all"

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
::  Section: psmux plugins
:: ---------------------------------------------------------------------
echo %BOLD%-- psmux plugins ---------------------------------------------------%RESET%
if exist "%USERPROFILE%\.psmux\plugins\" (
    echo   %GREEN%[OK]%RESET%      psmux plugins directory exists
    set /a PASS+=1 >nul
) else (
    echo   %RED%[MISSING]%RESET%  psmux plugins directory --run install.bat
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
    for %%f in ("%LOCALAPPDATA%\Microsoft\Windows\Fonts\JetBrainsMonoNerdFont*") do if exist "%%f" set "FONT_FOUND=%%~nxf"
)
:: Check system fonts
if not defined FONT_FOUND (
    if exist "%WINDIR%\Fonts" (
        for %%f in ("%WINDIR%\Fonts\JetBrainsMonoNerdFont*") do if exist "%%f" set "FONT_FOUND=%%~nxf"
    )
)

if defined FONT_FOUND (
    echo   %GREEN%[OK]%RESET%      JetBrainsMono Nerd Font installed
    set /a PASS+=1 >nul
) else (
    echo   %YELLOW%[WARN]%RESET%    JetBrainsMono Nerd Font not found
    echo              %DIM%Install with: winget install DEVCOM.JetBrainsMonoNerdFont%RESET%
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

:: :prepend_path_if_exists <directory>
::   Adds known standalone install directories to this process PATH.
:prepend_path_if_exists
    set "_PATHDIR=%~1"
    if not exist "!_PATHDIR!" exit /b
    echo !PATH! | find /I "!_PATHDIR!" >nul 2>&1
    if !errorlevel! equ 0 exit /b
    set "PATH=!_PATHDIR!;!PATH!"
    exit /b

:: :check_website_cli <name> <native_binary> <install_hint>
::   Match the native path checked by website_cli_install in install.bat.
:check_website_cli
    set "AI_NAME=%~1"
    set "AI_BINARY=%~2"
    set "AI_INSTALL=%~3"
    if exist "!AI_BINARY!" (
        echo   %GREEN%[OK]%RESET%      !AI_NAME! website installation --!AI_BINARY!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  !AI_NAME! website installation --install with: !AI_INSTALL!
        set /a FAIL+=1 >nul
    )
    exit /b

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
        echo   %RED%[MISSING]%RESET%  %TOOL_NAME% --install with: !INSTALL!
        set /a FAIL+=1 >nul
    )
    exit /b

:: :check_tool_min_version <name> <version_cmd> <version_line> <min_version> <install_hint>
::   Checks if a tool is on PATH and meets a minimum semantic version.
:check_tool_min_version
    set "TOOL_NAME=%~1"
    set "VER_CMD=%~2"
    set "VER_LINE=%~3"
    set "MIN_VERSION=%~4"
    set "INSTALL=%~5"

    where %TOOL_NAME% >nul 2>&1
    if !errorlevel! neq 0 (
        echo   %RED%[MISSING]%RESET%  %TOOL_NAME% --install with: !INSTALL!
        set /a FAIL+=1 >nul
        exit /b
    )

    set "VER_OUTPUT="
    set "LINE_NUM=0"
    for /f "tokens=*" %%v in ('%VER_CMD% 2^>^&1') do (
        set /a LINE_NUM+=1 >nul
        if !LINE_NUM! equ %VER_LINE% set "VER_OUTPUT=%%v"
    )

    set "CHECK_VERSION_OUTPUT=!VER_OUTPUT!"
    set "CHECK_MIN_VERSION=%MIN_VERSION%"
    powershell -NoProfile -Command "$m = [regex]::Match($env:CHECK_VERSION_OUTPUT, '\d+(\.\d+)+'); if (-not $m.Success) { exit 2 }; if ([version]$m.Value -ge [version]$env:CHECK_MIN_VERSION) { exit 0 } else { exit 1 }" >nul 2>&1
    if !errorlevel! geq 2 (
        echo   %YELLOW%[WARN]%RESET%    %TOOL_NAME% --could not parse version from: !VER_OUTPUT!
        set /a WARN+=1 >nul
    ) else if !errorlevel! equ 1 (
        echo   %YELLOW%[OUTDATED]%RESET% %TOOL_NAME% --!VER_OUTPUT! ^(need >= %MIN_VERSION%; run: %INSTALL%^)
        set /a WARN+=1 >nul
    ) else (
        echo   %GREEN%[OK]%RESET%      %TOOL_NAME% --!VER_OUTPUT!
        set /a PASS+=1 >nul
    )
    exit /b

:: :check_vulkan_sdk_env
::   Checks VULKAN_SDK points at a real SDK with shader tools.
:check_vulkan_sdk_env
    set "SDK_ENV="
    for /f "delims=" %%v in ('powershell -NoProfile -Command "$sdk = $env:VULKAN_SDK; if (-not $sdk) { $sdk = [Environment]::GetEnvironmentVariable('VULKAN_SDK', 'User') }; if (-not $sdk) { $sdk = [Environment]::GetEnvironmentVariable('VULKAN_SDK', 'Machine') }; if ($sdk) { $sdk }"') do set "SDK_ENV=%%v"
    if not defined SDK_ENV (
        echo   %RED%[MISSING]%RESET%  VULKAN_SDK --run install.bat, then restart the terminal
        set /a FAIL+=1 >nul
        exit /b
    )
    if exist "!SDK_ENV!\Bin\glslc.exe" (
        echo   %GREEN%[OK]%RESET%      VULKAN_SDK --!SDK_ENV!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  VULKAN_SDK --invalid path: !SDK_ENV!
        set /a FAIL+=1 >nul
    )
    exit /b

:: :check_winget_package <label> <package_id> <install_hint>
::   Checks whether a WinGet/MS Store package is installed.
:check_winget_package
    set "PKG_LABEL=%~1"
    set "PKG_ID=%~2"
    set "INSTALL=%~3"

    where winget >nul 2>&1
    if !errorlevel! neq 0 (
        echo   %YELLOW%[WARN]%RESET%    %PKG_LABEL% --cannot check ^(winget not found^)
        set /a WARN+=1 >nul
        exit /b
    )

    winget list --id "%PKG_ID%" --exact >nul 2>&1
    if !errorlevel! equ 0 (
        echo   %GREEN%[OK]%RESET%      %PKG_LABEL%
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  %PKG_LABEL% --install with: %INSTALL%
        set /a FAIL+=1 >nul
    )
    exit /b

:: :check_command_path_contains <label> <command> <path_text> <install_hint>
::   Checks whether a command resolves to a path containing expected text.
:check_command_path_contains
    set "PATH_LABEL=%~1"
    set "PATH_CMD=%~2"
    set "PATH_TEXT=%~3"
    set "INSTALL=%~4"

    set "FOUND_PATH="
    for /f "tokens=*" %%p in ('where "%PATH_CMD%" 2^>nul') do (
        echo %%p | find /I "%PATH_TEXT%" >nul 2>&1
        if !errorlevel! equ 0 set "FOUND_PATH=%%p"
    )

    if defined FOUND_PATH (
        echo   %GREEN%[OK]%RESET%      %PATH_LABEL% --!FOUND_PATH!
        set /a PASS+=1 >nul
    ) else (
        echo   %RED%[MISSING]%RESET%  %PATH_LABEL% --install with: %INSTALL%
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

:: :check_git_alias <alias_name> <expected_value>
::   Checks if a git alias is configured with the expected value.
:check_git_alias
    set "ALIAS_NAME=%~1"
    set "EXPECTED=%~2"

    set "ACTUAL="
    for /f "tokens=*" %%v in ('git config --global alias.%ALIAS_NAME% 2^>nul') do set "ACTUAL=%%v"
    if not defined ACTUAL (
        echo   %RED%[MISSING]%RESET%  git %ALIAS_NAME% --run install.bat to configure
        set /a FAIL+=1 >nul
    ) else if "!ACTUAL!" neq "!EXPECTED!" (
        echo   %YELLOW%[OUTDATED]%RESET% git %ALIAS_NAME% differs from install.bat --run install.bat to configure
        set /a WARN+=1 >nul
    ) else (
        echo   %GREEN%[OK]%RESET%      git %ALIAS_NAME%
        set /a PASS+=1 >nul
    )
    exit /b
