echo off
setlocal
cd /d %~dp0
if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage
if [%4]==[] goto usage
if [%5]==[] goto usage
if [%6]==[] goto usage
if [%7]==[] goto usage

set localhost=%1
set subscriptionId=%2
set tenantId=%3
set clientId=%4
set secretAccessKey=%5
set tagName=%6
set tagValue=%7

echo localhost: %localhost%
echo subscriptionId: %subscriptionId%
echo tenantId: %tenantId%
echo clientId: %clientId%
echo secretAccessKey: %secretAccessKey%
echo tagName: %tagName%
echo tagValue: %tagValue%

echo { "retry_join": ["provider=azure tag_name=%tagName% tag_value=%tagValue% tenant_id=%tenantId% client_id=%clientId% subscription_id=%subscriptionId% secret_access_key=%secretAccessKey%"]} > .\config\azure.json


set serviceBinPath= %~dp0join-cluster-azure.bat
echo creating service %serviceBinPath% 
nssm install consul %serviceBinPath% %localhost%
nssm start consul
echo Done.
goto :eof
:usage
echo Missing arguments!
echo USAGE: install-consul-azure.bat MachineIpAddress AzureSubscriptionId AzureTenantId AzureClientId AzureSecret AzureTagName AzireTagValue
echo EXAMPLE: install-consul-azure.bat 10.0.0.28 f112e765-a979-4ff0-90e6-f51ed0650a90 1f3c0620-b1bf-46d0-bceb-d4ef97bbbc91 4fc22021-e319-431e-b014-c09f96d3e018 e5901352-757a-48c7-a6ac-0486ebd525c7 consul production-env
exit /B 1