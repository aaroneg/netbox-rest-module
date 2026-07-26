<#
.SYNOPSIS
Get circuit provider by name

.DESCRIPTION
Get circuit provider by name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
The name of the circuit provider
#>
function Get-NBCircuitProviderByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBCircuitProvidersAPIPath -value $name

}