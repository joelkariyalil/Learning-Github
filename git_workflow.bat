@echo off
setlocal enabledelayedexpansion

set "work_dir="
set "branch="
set "comment="

set /a line_count=0

for /f "usebackq delims=" %%A in (config.txt) do (
    set /a line_count+=1
    if !line_count! equ 1 set "work_dir=%%~A"
    if !line_count! equ 2 set "branch=%%A"
	if !line_count! equ 3 set "comment=%%A"
)

if not exist "%work_dir%" (
    echo Error: Directory does not exist - "%work_dir%"
    pause
    exit /b
)

cd "%work_dir%"

git stash
git fetch origin
git rebase origin
git stash pop
git add .

git commit -m "%comment%"
git push origin "%branch%"