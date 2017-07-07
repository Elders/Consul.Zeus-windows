echo off
setlocal
cd /d %~dp0
if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage

set localhost=%1
set tagName=%2
set tagValue=%3
echo localhost:%localhost%
echo tagName:%tagName%
echo tagValue:%tagValue% 

consul.exe agent -server -ui -advertise=%localhost% -client=%localhost% -config-dir=config -bootstrap-expect=2 -retry-join-azure-tag-name=%tagName% -retry-join-azure-tag-value=%tagValue%

echo Done.
goto :eof
:usage
echo Missing arguments: localhost or tagName or tagValue
exit /B 1