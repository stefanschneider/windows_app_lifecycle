@echo off

if not exist "%~dp0\compile.exe" (
  call %~dp0\build.bat
)

"%~dp0\compile.exe" %*
