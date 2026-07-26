<#
.SYNOPSIS
Get a circuit by Netbox object ID

.DESCRIPTION
Get a circuit by Netbox object IDs

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID number of an existing Netbox object
#>
function Get-NBCircuitByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitsAPIPath -id $id

}