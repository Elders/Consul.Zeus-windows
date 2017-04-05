echo off
setlocal
cd /d %~dp0
if [%1]==[] goto usage
if [%2]==[] goto usage

set localhost=%1
set joinNode=%2
echo localhost:%localhost%
echo joining:%joinNode% 

consul.exe agent -server -ui -advertise=%localhost% -retry-join=%joinNode% -client=%localhost% -config-dir=config -bootstrap-expect=2

echo Done.
goto :eof
:usage
echo Missing arguments: localhost or joinNode
exit /B 1