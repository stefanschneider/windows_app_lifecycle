:: msbuild must be in path
SET PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework64\v4.0.30319;%WINDIR%\SysNative
where msbuild
if errorLevel 1 ( echo "msbuild was not found on PATH" && exit /b 1 )

set SystemDrive=%WINDIR:~0,2%
set OS=Windows_NT

pushd %~dp0..
  set TEMP=%CD%\TEMP
  set TMP=%TEMP%
  mkdir %TEMP%
  
  .nuget\NuGet.exe restore
  msbuild "%CD%\WindowsAppLifecycle.sln" /t:Build /p:Configuration=Release
popd
