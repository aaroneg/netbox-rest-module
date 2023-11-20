function Get-NBVMClusterTypeByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VirtualizationClusterTypesAPIPath -value $name

}