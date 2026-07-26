<#
.SYNOPSIS
Get a circuit by the provider-supplied circuit ID

.DESCRIPTION
Get a circuit by the provider-supplied circuit ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER cid
Circuit name/id
#>
function Get-NBCircuitByCID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$cid
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBCircuitsAPIPath -field cid -value $cid).results

}