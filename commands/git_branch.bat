@echo off
TITLE New Git Branch


REM change directory into the parent directory
cd ..






REM Give the branch a name and select it
echo This script creates and activates a new branch for the project to prevent messing up the main branch.
echo ---------------------------------------------------------------------------
echo
set /p new_branch="Want to create a new branch? Y?N: "
if new_branch == "Y" (
    set /p emergeny_branch="Will this be an emergency-branch? Y?N: "
    if emergency_branch == "Y" (
        set /p branch_name="Enter the emergency-branch: "        
    ) else (
        set /p branch_name="Enter the new-branch-name: "                
    )
    REM Select the new branch
    git checkout "%branch_name%"
) else (    
    REM Use an existing branch
    set /p existing_branch_name="Enter an existing-branch-name: "
    git checkout "%existing_branch%"
)
echo ---------------------------------------------------------------------------
echo You will use this branch
echo ---------------------------------------------------------------------------




REM Merge branches
set /p merge_branch="Will you like to merge your branches? Y?N: "


REM Add the file to the Git repository
git add .


REM Request the commit message from the user
set /p commit_message="Enter the commit message: "

REM Commit the changes with the provided message
git commit -m "%commit_message%"


if merge_branch == "Y" (
    echo Merging branches ...
    REM if an emergency branch then delete it while merging the branch name
    git checkout main
    if new_branch == "Y"  (        
        git merge "%branch_name%"
        REM Delete the emergency branch now
        REM If done with the other branch create decide if to delete or keep it while merging the details to the main branch
        REM Request to delete the alternate branch
        set /p delete_branch="Are you done with the branch and would like to delete it? Y?N: "
        if delete_branch == "Y" (
            git branch -d "%branch_name%"
        )
    ) else (    
        git merge "%existing_branch_name%"
        REM Delete the emergency branch now
        REM If done with the other branch create decide if to delete or keep it while merging the details to the main branch
        REM Request to delete the alternate branch
        set /p delete_branch="Are you done with the branch and would like to delete it? Y?N: "
        if delete_branch == "Y" (
            git branch -d "%existing_branch_name%"
        )
    )
    echo Merged branches!
)


REM Push the changes to the remote repository
git push -u origin main
