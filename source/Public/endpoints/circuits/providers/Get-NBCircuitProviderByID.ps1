<#
.SYNOPSIS
Get circuit provider by ID

.DESCRIPTION
Get circuit provider by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the object to retrieve
#>
function Get-NBCircuitProviderByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitProvidersAPIPath -id $id

}