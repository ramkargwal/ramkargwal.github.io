@echo off
echo Naya "sk folder tools" menu banaya ja raha hai...

:: एडमिन परमिशन चेक
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Kripya is file par Right-Click karke "Run as administrator" chunein!
    pause
    exit /b
)

:: 1. पुरानी सेटिंग्स को साफ करना (ताकि कोई टकराव न हो)
reg delete "HKCR\Directory\shell\skfoldertools" /f >nul 2>&1

:: 2. मुख्य मेनू (sk folder tools) केवल फोल्डर के लिए बनाना
reg add "HKCR\Directory\shell\skfoldertools" /v "MUIVerb" /t REG_SZ /d "sk folder tools" /f
reg add "HKCR\Directory\shell\skfoldertools" /v "SubCommands" /t REG_SZ /d "skfolder.cmd1;skfolder.cmd2;skfolder.cmd3;skfolder.cmd4" /f

:: 3. सीधे चारों कमांड्स को CommandStore में जोड़ना

:: कमांड 1: CopyFolderTree.ps1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd1" /v "MUIVerb" /t REG_SZ /d "Copy Folder Tree" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd1\command" /ve /t REG_SZ /d "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:\SudarshanTools\FolderTools\CopyFolderTree.ps1\" \"%%1\"" /f

:: कमांड 2: Folder_File_info.ps1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd2" /v "MUIVerb" /t REG_SZ /d "Folder File Info" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd2\command" /ve /t REG_SZ /d "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:\SudarshanTools\FolderTools\Folder_File_info.ps1\" \"%%1\"" /f

:: कमांड 3: html_report.py
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd3" /v "MUIVerb" /t REG_SZ /d "HTML Report" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd3\command" /ve /t REG_SZ /d "python.exe \"C:\SudarshanTools\FolderTools\html_report.py\" \"%%1\"" /f

:: कमांड 4: Play_Quiz_Json_Data.ps1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd4" /v "MUIVerb" /t REG_SZ /d "Play Quiz Json Data" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\skfolder.cmd4\command" /ve /t REG_SZ /d "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:\SudarshanTools\FolderTools\Play_Quiz_Json_Data.ps1\" \"%%1\"" /f

echo.
echo "sk folder tools" menu safaltapurvak bana diya gaya hai!
pause