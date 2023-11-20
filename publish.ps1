del F:\nuget\netbox-rest-module.0.0.1.nupkg
del "C:\Users\Aaron\Documents\powershell\modules\netbox-rest-module" -Recurse -Force 
# Publish to a file share repo - the NuGet API key must be a non-blank string
$publishModuleSplat = @{
    Path = 'F:\git\netbox-rest-module\Build\netbox-rest-module'
    Repository = 'LocalPsRepo'
    NuGetApiKey = 'AnyStringWillDo'
}
Publish-Module @publishModuleSplat -Force 
install-module netbox-rest-module -Scope CurrentUser -Force


<#
# Register a file share on my local machine
$registerPSRepositorySplat = @{
    Name = 'LocalPSRepo'
    SourceLocation = '\\localhost\nuget'
    ScriptSourceLocation = '\\localhost\nuget'
    InstallationPolicy = 'Trusted'
}
Register-PSRepository @registerPSRepositorySplat
#>