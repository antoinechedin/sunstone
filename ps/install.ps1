Push-Location "$PSScriptRoot\.."

Copy-Item -Path ".\build\sunstone-color-theme.json" -Destination "%USERPROFILE%\.vscode\extensions" -Force
