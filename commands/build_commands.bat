@echo off
set /p runScript=Do you want to run the build script now? (y/n)

if /i "%runScript%"=="y" (
    cd ..
    echo Running build script... Please ensure you have setup all necessary configurations to enable this run smoothly.
    set /p buildAndroid=Do you want to build for android? (y/n)
    if /i "%buildAndroid%"=="y" (
        REM Run android build here
        echo Running android build...
        flutte build android
    ) else {
        echo Android build stopped.
        set /p buildIos=Do you want to build for ios? (y/n)
        if /i "%buildIos%"=="y" (
            REM Run ios build here
            echo Running ios build...
            flutte build ios
        ) else {
            echo Ios Build terminated.
            exit
        }
    }
    REM Add your script commands here
) else (
    echo Script terminated.
    exit
)
