function Get-NBVMVirtualDiskByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $NBVirtualDisksAPIPath -value $name

}