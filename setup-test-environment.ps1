#! /usr/bin/pwsh
if(!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable)) {
    Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore -Force -Scope CurrentUser
    Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault -AllowClobber
}
if(!(Get-Module netbox-rest-module -ListAvailable)) {
    Install-Module netbox-rest-module, Microsoft.PowerShell.SecretStore -Force -Scope CurrentUser
}
Import-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
# Read or create a netbox config object
try {
    $config=Import-Clixml $PSScriptRoot\config.xml
}
catch {
    $config=@{
        serverAddress = Read-Host -Prompt "IP address or hostname of Netbox server"
    }
    $config | Export-Clixml $PSScriptRoot\config.xml
}
Import-Module netbox-rest-module

# Get or create the API credential
try {
    $Secret=Get-Secret -Name $Config.serverAddress -AsPlainText -ErrorAction Stop
}
catch {
    $Secret=Read-Host -Prompt "API Key"
    Set-Secret -Name $config.serverAddress -Secret $Secret
}

$Connection = New-NBConnection -DeviceAddress $config.serverAddress -ApiKey $Secret -Passthru -SkipCertificateCheck
Write-Output "Connection initiated:"
$Connection
