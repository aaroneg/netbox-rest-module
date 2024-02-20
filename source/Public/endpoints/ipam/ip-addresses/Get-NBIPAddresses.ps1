function Get-NBIPAddresses {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItems -apiConnection $Connection -RelativePath $IPAddressAPIPath

}