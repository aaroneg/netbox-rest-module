function Get-NBVMByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -value $name

}