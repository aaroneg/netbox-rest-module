function Find-NBVMInterfacesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -name $name

}