function Get-NBGenericItemByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$Path,
		[Parameter(Mandatory=$true,Position=1)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCablesAPIPath -id $id

}