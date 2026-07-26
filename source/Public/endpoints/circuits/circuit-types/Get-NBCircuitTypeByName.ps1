<#
.SYNOPSIS
Get a circuit by name

.DESCRIPTION
Get a circuit by name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
The name of the object
#>
function Get-NBCircuitTypeByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBCircuitTypesAPIPath -value $name

}