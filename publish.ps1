#! /usr/bin/pwsh
. $PSScriptRoot\version.ps1

$publishModuleSplat = @{
    Path = "$PSScriptRoot\Build\netbox-rest-module\$moduleVersionTarget"
    Repository = 'PSGallery'

}

Publish-Module @publishModuleSplat -NuGetApiKey (Read-Host -Prompt 'API Key') -Verbose -Debug
install-module netbox-rest-module -Scope CurrentUser -Force -Repository PSGallery -AllowPrerelease
