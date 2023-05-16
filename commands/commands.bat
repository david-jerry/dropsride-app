@echo off

REM chanfe directory into the parent directory
cd ..

REM Run the clean command to clean the project first
flutter clean

REM Run the flutter pub get to get files first
flutter pub get

REM Run the flutter native splash command to style the command
flutter pub run flutter_native_splash:create
