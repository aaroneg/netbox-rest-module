<#
.SYNOPSIS
Get object by name

.DESCRIPTION
Get object by name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
Name of the object
#>
function Get-NBVirtualCircuitTypeByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBVirtualCircuitTypessAPIPath -value $name

}