echo off
setlocal
cd /d %~dp0
if [%1]==[] goto usage

set localhost=%1
echo localhost:%localhost%

consul.exe agent -server -ui -advertise=%localhost% -client=%localhost% -config-dir=config -bootstrap-expect=2

echo Done.
goto :eof
:usage
echo Missing arguments: localhost
exit /B 1