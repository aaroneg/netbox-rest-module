function Get-NBVMInterfaceForVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -field 'virtual_machine_id' $id).results

}