function Get-NBVMVirtualDiskForVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBVirtualDisksAPIPath -field 'virtual_machine_id' $id).results

}