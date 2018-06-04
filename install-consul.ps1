param(
    [string]$AzureSubscriptionId,

    [string]$AzureTenantId,

    [string]$AzureClientId,

    [string]$AzureSecret,

    [string]$AzureTagName = 'consul',

    [string]$AzureTagValue, 

    [string]$localnodeIP, 

    [string[]]$ConsulArgs,

    [string[]]$ZeusArgs = ("machine","-f"),

    [string[]]$CheckInterval = '5m'
)

Add-Type -AssemblyName System.Web

if (!$localnodeIP) {
    $temp = Get-NetIpaddress | Where addressstate -EQ preferred | Where PrefixOrigin -EQ Dhcp | Select IPAddress
    $localnodeIP = $temp.IPAddress
}

$AzureSecret   = [System.Web.HttpUtility]::UrlEncode($AzureSecret)
$path = (Get-Item -Path ".\").FullName
$ZeusArgs = ,"zeus\Zeus.exe" + $ZeusArgs
$jsonConfig = [ordered]@{
    data_dir= "data"
    check_update_interval="$CheckInterval"
    ports =@{
        http=8500
    }
    log_level= "err"
    checks = @(
            @{
                id="sys-health"
			    name="System Information"
			    args=$ZeusArgs
			    interval="$CheckInterval"
			    timeout="1m"
            }
        )
    enable_script_checks=[bool]"true"
}

$jsonConfig | ConvertTo-Json -Depth 4 | Out-File .\config\config.json -NoNewLine -Encoding default

$destination = "$path\consul.zip"
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$client = New-Object System.Net.WebClient
$client.DownloadFile("https://releases.hashicorp.com/consul/1.1.0/consul_1.1.0_windows_amd64.zip", $destination)

Expand-Archive -path "$path\consul.zip"  -DestinationPath $path -Force

if (!$AzureSubscriptionId -and !$AzureClientId -and !$AzureTenantId -and !$AzureSecret -and !$AzureTagValue) {
    Write-Host "Configuring without Azure integration"
} 

elseif (!$AzureSubscriptionId -or !$AzureClientId -or !$AzureTenantId -or !$AzureSecret -or !$AzureTagValue) {
    return Write-Host "All Azure parameters are required to configure Azure integration."
}

else {
    "{ `"retry_join`": [`"provider=azure tag_name=$AzureTagName tag_value=$AzureTagValue tenant_id=$AzureTenantId client_id=$AzureClientId subscription_id=$AzureSubscriptionId secret_access_key=$AzureSecret`"]}" | Out-File .\config\azure.json -NoNewLine -Encoding default
}

Start-Process -FilePath "nssm.exe" -ArgumentList "install consul $path\consul.exe agent -advertise=$localnodeIP -client=$localnodeIP -config-dir=config $ConsulArgs"
Start-Process -FilePath "nssm.exe" -ArgumentList "start consul"