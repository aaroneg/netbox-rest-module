function Get-NBIPRangeAvailableIPsByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemsByID -apiConnection $Connection -RelativePath "$IPRangesAPIPath/$id/available-ips"

}