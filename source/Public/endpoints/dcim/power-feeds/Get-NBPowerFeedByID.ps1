<#
.SYNOPSIS
Get object by ID

.DESCRIPTION
Get object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The object ID to return
#>
function Get-NBPowerFeedByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBPowerFeedsAPIPath -id $id

}