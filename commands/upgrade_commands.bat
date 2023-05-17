@echo off

REM chanfe directory into the parent directory
cd ..

REM Run the flutter doctor command to figure out if there is any thing wrong with the command
flutter doctor && flutter upgrade

exit

