:: msbuild must be in path
SET PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework64\v4.0.30319;%WINDIR%\SysNative
where msbuild
if errorLevel 1 ( echo "msbuild was not found on PATH" && exit /b 1 )

rmdir /S /Q output
rmdir /S /Q packages
bin\nuget restore || exit /b 1

SET GOPATH=%CD%\diego-release
SET GOBIN=%GOPATH%\bin
SET PATH=%GOBIN%;%PATH%

pushd %GOPATH%\src\code.cloudfoundry.org\diego-ssh
      go install github.com/onsi/ginkgo/ginkgo
::      ginkgo -r -noColor -skipPackage="ssh-proxy" . || exit /b 1
popd
go build -o diego-sshd.exe code.cloudfoundry.org/diego-ssh/cmd/sshd || exit /b 1

MSBuild WindowsAppLifecycle.sln /t:Rebuild /p:Configuration=Release || exit /b 1
:: packages\nspec.0.9.68\tools\NSpecRunner.exe Builder.Tests\bin\Release\BuilderTests.dll || exit /b 1
:: packages\nspec.0.9.68\tools\NSpecRunner.exe Launcher.Tests\bin\Release\LauncherTests.dll || exit /b 1

pushd %GOPATH%\src\code.cloudfoundry.org\healthcheck
      go install github.com/onsi/ginkgo/ginkgo
::      ginkgo -r -noColor . || exit /b 1
popd
go build -o healthcheck.exe code.cloudfoundry.org/healthcheck/cmd/healthcheck || exit /b 1


bin\bsdtar -czvf windows_app_lifecycle.tgz --exclude log -C Builder\bin . -C ..\..\Launcher\bin . -C ..\..\winpty . -C .. ./diego-sshd.exe ./healthcheck.exe || exit /b 1
for /f "tokens=*" %%a in ('git rev-parse --short HEAD') do (
    set VAR=%%a
    )

mkdir output
move /Y windows_app_lifecycle.tgz output\windows_app_lifecycle-%VAR%.tgz || exit /b 1
