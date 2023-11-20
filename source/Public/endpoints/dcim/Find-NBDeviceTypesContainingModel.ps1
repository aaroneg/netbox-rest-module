function Find-NBDeviceTypesContainingModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$model
	)
	Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ic' -value $model

}