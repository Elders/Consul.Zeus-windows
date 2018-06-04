
# Consul.Zeus-windows

Consul-Zeus-windows is a [Consul](https://www.consul.io) installation script with built in [Zeus](https://github.com/Elders/Zeus) checks for monitoring.

#### Installation

Consul-Zeus for windows is installed via the *install-consul.ps1* script. It will install as a Windows service, using [NSSM](https://nssm.cc/). By default, Consul will install in agent role and bind to the first real IP it finds.
You can install the default agent by running the script, either from the PowerShell terminal or via CommandPrompt:

> powershell .\install-consul.ps1

This will install Consul as a service on the selected machine. You are able to provide configuration parameters to the script, those include all possible Consul Arguments, all possible Zeus Arguments, Check interval and Azure Integration credentials.
Please note that if your server has more than one IP, you need to specify on which address you want Consul to communicate. This can be achieved with the *localnodeIP* argument.

##### CheckInterval

Setting this variable will make consul execute Zeus checks on specified interval. Please note that the default value for Consul checks is 5 minutes. Setting up this bellow 5 minutes is not recommended because it will make Consul execute a lot of checks and it will result into a lot of data transfered between the Consul Cluster Nodes.

##### ZeusArgs

Zeus Arguments can be passed in a comma seperated list, keeping in mind that we escape the hyphen with *`*, as follows:

> powershell .\install-consul.ps1 -ZeusArgs machine,\`-f,\`-e,cpu.usage:below:30

This will return default information about the machine and will register an error if CPU usage is above 30 percent.
For more information about the extent of Zeus arguments you can check [Zeus Documentation](https://github.com/Elders/Zeus)

##### ConsulArgs

Upon installation you can pass on all Consul arguments in a comma seperated list, keeping in mind that we escape the hyphen with *`*, as follows:

> powershell .\install-consul.ps1 -ConsulArgs \`-server,\`-ui,\`-bootstrap,\`-datacenter=Test

This example will install consul in Server mode and bootstrap it. It will also enable to Web UI and set the datacentername to Test. For more information on Consul options. you can read the full [Consul](https://www.consul.io/docs/agent/cloud-auto-join.html) documentation.

##### Azure Service Discovery

Consul-Zeus supports Azure Service Discovery based on Azure tags. You can use this by passing on the 5 needed Azure parameters - Subscription, Tenant, and Client Ids, Azure Secret and Tag Value. Please read the full [Consul](https://www.consul.io/docs/agent/cloud-auto-join.html) documentation.

Here is an example installation.

> powershell .\install-consul.ps1 -AzureSubscriptionId {} -AzureTenantId {} -AzureClientId {} -AzureSecret {} -AzureTagValue {} -ConsulArgs \`-server,\`-ui,\`-bootstrap\` -CheckInterval "10m" -ZeusArgs machine,\`-f,\`-e,cpu.usage:below:30

##### Configuration
Consul uses the configuration files in the Config directory, should you need to change those post installation, you can edit the files directly and just restart the Consul Service.

##### Uninstall

You can run the uninstall-consul.bat, which will stop and remove the Consul service.

##### READ MORE

Please note that those are pretty basic Consul configurations, and they are not production ready. Please read the full [Consul](https://www.consul.io/docs/) and [Zeus](https://github.com/Elders/Zeus) Documentations so that you could have an optimal setup for your system.

