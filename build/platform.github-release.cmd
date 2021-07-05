@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

SETLOCAL ENABLEDELAYEDEXPANSION

echo -^> github-release vendor-expat

if not exist release\ echo Error - no release & exit 1

set GITHUB_PROJECT=vendor-%PROJECT%

echo -^> release %GITHUB_PROJECT% v%VERSION%

git pull --tags origin main
git rev-parse --quiet "v%VERSION%" 1>NUL 2>NUL
if not errorlevel 1 goto tagExists
git tag -a v%VERSION% -m "v%VERSION%"
git push --tags
echo Create release %GITHUB_PROJECT% v%VERSION%
github-release release --repo %GITHUB_PROJECT% --tag v%VERSION% --name "v%VERSION%" --description "Release"
pushd release
for /r %%i in (%PROJECT%-%VERSION%*.7z) do echo Upload %%~nxi & github-release upload --repo %GITHUB_PROJECT% --tag v%VERSION% --name "%%~nxi" --file "%%i"
for /r %%i in (%PROJECT%-%VERSION%*.csv) do echo Upload %%~nxi & github-release upload --repo %GITHUB_PROJECT% --tag v%VERSION% --name "%%~nxi" --file "%%i"
popd

goto :eof

:tagExists
echo Release already exists
exit 0
