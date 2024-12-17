function Get-NBGenericItems {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$Path,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $Path
}