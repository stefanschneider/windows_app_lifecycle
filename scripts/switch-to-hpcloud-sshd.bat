SET GOPATH=%CD%\diego-release

pushd %GOPATH%\src\code.cloudfoundry.org\diego-ssh
	git remote add hpcloud https://github.com/hpcloud/diego-ssh
	git fetch hpcloud
	git checkout -b w2016 hpcloud/w2016 || exit /b 1
popd
