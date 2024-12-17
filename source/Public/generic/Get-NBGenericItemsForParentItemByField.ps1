function Get-NBGenericItemsForParentItemByField {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$Path,
		[Parameter(Mandatory=$true,Position=0)][string]$Field,
		[Parameter(Mandatory=$true,Position=0)][string]$value

	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $Path -field $Field -value $value).results

}