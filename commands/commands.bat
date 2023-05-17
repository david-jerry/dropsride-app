@echo off

REM chanfe directory into the parent directory
cd ..

REM Run the flutter pub get to get files first
flutter clean && flutter pub get && flutter run


