@echo off

REM Add the file to the Git repository
git add .

REM Request the commit message from the user
set /p commit_message="Enter the commit message: "

REM Commit the changes with the provided message
git commit -m "%commit_message%"

REM Push the changes to the remote repository
git push -u origin main
