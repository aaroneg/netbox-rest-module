<#
.SYNOPSIS
Get Object by ID

.DESCRIPTION
Get Object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
Object ID
#>
function Get-NBRackTypeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBRackTypesAPIPath -id $id

}