function Get-NBVMClusterByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -value $name

}