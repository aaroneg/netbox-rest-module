<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Connection
Parameter description

.PARAMETER id
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-NBASNAvailableInRangeByID {
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$id
	)
	Get-ApiItemByPath -apiConnection $Connection -Path $ASNRangeAPIPath/$id/available-asns/
}