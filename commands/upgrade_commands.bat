@echo off

REM chanfe directory into the parent directory
cd ..

REM Run the flutter doctor command to figure out if there is any thing wrong with the command
flutter doctor


REM Run the flutte upgrade command to ensure you are using the latest flutter package
flutter upgrade
