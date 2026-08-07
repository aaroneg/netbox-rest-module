function Remove-NBConfig {
	[CmdletBinding()]
	param (
		[Parameter(Position=0)][string]$TargetPath='.'
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Removing configuration file $("$TargetPath\nbconfig.xml")"
	if(!(Test-Path -Path $TargetPath\nbconfig.xml -PathType Leaf)) {
		Write-Verbose "[$($MyInvocation.MyCommand.Name)] No configuration was present, returning"
		return
	}
	else {
		try {Remove-item $TargetPath\nbconfig.xml -ErrorAction Stop}
		catch {"Failed to remove configuration file $("$TargetPath\nbconfig.xml")"}
	}

}