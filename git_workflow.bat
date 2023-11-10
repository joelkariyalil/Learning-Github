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
git commit -m "%message%"
git push origin "%branch%"