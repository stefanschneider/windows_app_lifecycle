@echo off

if not exist "%~dp0\release.exe" (
  call %~dp0\build.bat
)

"%~dp0\release.exe" %*
