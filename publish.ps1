try {Get-PSRepository 'LocalPSRepo' -ErrorAction Stop} 
catch {
	$registerPSRepositorySplat = @{
		Name = 'LocalPSRepo'
		SourceLocation = '\\localhost\nuget'
		ScriptSourceLocation = '\\localhost\nuget'
		InstallationPolicy = 'Trusted'
	}
	Register-PSRepository @registerPSRepositorySplat
}
# Publish to a file share repo - the NuGet API key must be a non-blank string
$publishModuleSplat = @{
    Path = "$PSScriptRoot\Build\netbox-rest-module\0.0.1"
    Repository = 'LocalPsRepo'
    NuGetApiKey = 'AnyStringWillDo'
}
Publish-Module @publishModuleSplat -Force -Verbose -Debug
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