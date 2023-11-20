function Get-NBDeviceTypeByModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$model
	)
	(Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ie' -value $model).results

}