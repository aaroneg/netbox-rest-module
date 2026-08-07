function Read-NBConfig {
	[CmdletBinding()]
	[Alias('Get-NBconfig','Load-NBConfig')]
	param (
		[Parameter(Position=0)][string]$TargetPath='.'
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying to read configuration file"
	if(!(Test-Path -Path $TargetPath\nbconfig.xml -PathType Leaf)) {throw "No configuration file present - use Write-NBConfig to create a configuration file in folder '$TargetPath'"}
	try {$Global:nbconfig=Import-Clixml $TargetPath\nbconfig.xml}
	catch {throw 'Use Write-NBConfig to create a configuration file in folder "$TargetPath"'}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Netbox connection information loaded for $($Global:nbconfig.serverAddress) - stored in `$nbconfig"	
}
