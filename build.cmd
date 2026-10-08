@echo off
rem One-command build on Windows: runs build.ps1 for this invocation only,
rem without changing the PowerShell execution policy.
rem Usage (PowerShell or cmd, from anywhere):  .\build.cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
exit /b %ERRORLEVEL%
