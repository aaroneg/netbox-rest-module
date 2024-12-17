function Get-NBGenericItemByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$Path,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $Path -value $name

}