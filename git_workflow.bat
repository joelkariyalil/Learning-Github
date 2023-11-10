@echo off

:: Read the contents of config.txt and assign them to variables
for /f "tokens=*" %%A in (config.txt) do (
    set "message=%%A"
    set "branch=%%A"
)

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