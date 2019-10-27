@ECHO OFF
#PowerShell.exe -Command "&‘%~dpn0.ps1'"


    PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"


PAUSE