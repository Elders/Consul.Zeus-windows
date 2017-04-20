echo off
setlocal
cd /d %~dp0
if [%1]==[] goto usage
if [%2]==[] goto usage

set localhost=%1
set joinNode=%2
echo localhost:%localhost%
echo joining:%joinNode%
set serviceBinPath= %~dp0join-cluster.bat
echo creating service %serviceBinPath%
nssm install consul %serviceBinPath% %localhost% %joinNode%
nssm start consul
echo Done.
goto :eof
:usage
echo Missing arguments: localhost or joinNode
echo EXAMPLE USAGE: create-service.bat 10.0.0.28 10.0.0.50
echo WHERE 10.0.0.28 is the private ip of the current machine and 10.0.0.50 is another machine where consul is ALREADY RUNNING OR WILL BE RUN 
exit /B 1