<#
.SYNOPSIS
Get circuit provider network object by id

.DESCRIPTION
Get circuit provider network object by id

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the object to retrieve
#>
function Get-NBCircuitProviderNetworkByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitProviderNetworksAPIPath -id $id

}