. $PSScriptRoot\version.ps1

$publishModuleSplat = @{
    Path = "$PSScriptRoot\Build\netbox-rest-module\$moduleVersionTarget"
    Repository = 'PSGallery'

}
Publish-Module @publishModuleSplat -NuGetApiKey (Read-Host -Prompt 'API Key')
install-module netbox-rest-module -Scope CurrentUser -Force
