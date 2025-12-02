@echo off
REM Setup Git hooks for automatic documentation updates (Windows)

setlocal enabledelayedexpansion

set "REPO_ROOT=%~dp0"
set "HOOKS_DIR=%REPO_ROOT%.githooks"
set "GIT_HOOKS_DIR=%REPO_ROOT%.git\hooks"

echo 🔧 Setting up Git hooks...

REM Create .git/hooks if it doesn't exist
if not exist "%GIT_HOOKS_DIR%" mkdir "%GIT_HOOKS_DIR%"

REM Copy hooks (without extensions on Windows)
copy "%HOOKS_DIR%\post-commit" "%GIT_HOOKS_DIR%\post-commit" >nul
copy "%HOOKS_DIR%\pre-push" "%GIT_HOOKS_DIR%\pre-push" >nul

REM Configure Git to use custom hooks directory
cd /d "%REPO_ROOT%"
git config core.hooksPath .githooks

echo ✅ Git hooks installed successfully
echo.
echo Hooks configured:
echo   - post-commit: Updates documentation after each commit
echo   - pre-push: Verifies documentation before pushing
echo.
echo To manually run documentation update:
echo   python update_docs.py
echo.
pause
