<#
.SYNOPSIS
Get objects by type

.DESCRIPTION
Get objects by type

.PARAMETER Connection
The connection object to use, if not using default.

.NOTES
This CMDlet may not return all results if the API has a hard limit set.
#>
function Get-NBMacAddresses {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $MACAddressAPIPath

}