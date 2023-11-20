function Test-NBConnection {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=0)][object]$NBConnection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying to connect"
	try {
		"Connection OK`nNetbox Version: "+(Get-NBStatus -Connection $NBConnection)."netbox-version"
	}
	catch {
		write-error "failed"
		$NBConnection
	}
}