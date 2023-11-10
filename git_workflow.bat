@echo off
setlocal enabledelayedexpansion

:: Read the contents of config1.txt and assign them to variables
set "work_dir="
set "branch="
set /a line_count=0

:: Process config1.txt
for /f "usebackq delims=" %%A in (config1.txt) do (
    set /a line_count+=1
    if !line_count! equ 1 set "work_dir=%%~A"
    if !line_count! equ 2 set "branch=%%A"
)

echo "Work Directory: !work_dir!"
echo "Branch: !branch!"

:: Check if directory exists
if not exist "%work_dir%" (
    echo Error: Directory does not exist - "%working_directory%"
    pause
    exit /b 1
)

:: Change the working directory

cd /d "%work_dir%"

:: Execute Git commands with the read values
git stash
git fetch origin
git rebase origin
git stash pop
git add .

:: Create an AutoIt input dialog to collect the comment message
:: Save the comment to a temporary file
echo $input = InputBox("Enter Comment", "Please enter your comment:") > "%temp%\comment.au3"
echo FileWrite("%temp%\comment.txt", $input) >> "%temp%\comment.au3"
"C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "%temp%\comment.au3"

:: Read the comment from the temporary file
set /p message=<"%temp%\comment.txt"

:: Remove the temporary AutoIt script and comment file
del "%temp%\comment.au3"
del "%temp%\comment.txt"

git commit -m "%message%"
git push origin "%branch%"

:: Display a "Press any key to continue..." message
pause