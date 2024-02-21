function Get-NBDeviceInterfaceForDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -field 'device_id' $id).results

}