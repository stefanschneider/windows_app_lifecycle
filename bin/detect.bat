@echo off

if not exist "%~dp0\detect.exe" (
  call %~dp0\build.bat
)

"%~dp0\detect.exe" %*

