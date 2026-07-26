<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER paginate
Parameter description

.PARAMETER Connection
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-NBASNRanges {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][switch]$paginate,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if($paginate){Get-ApiItems2 -apiConnection $Connection -RelativePath $ASNRangeAPIPath}
	else{Get-ApiItems -apiConnection $Connection -RelativePath $ASNRangeAPIPath}
}
