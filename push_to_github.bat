@echo off
title Push ServiceNow Documentation to GitHub
cd /d "C:\ServiceNow_Import_Data_Documentation"
echo ========================================================
echo Pushing ServiceNow Documentation to Dev-cs707/SkillWallet
echo ========================================================
"C:\Users\acer\.gemini\antigravity\scratch\mingit\cmd\git.exe" push -u origin main
echo.
echo Done!
pause
