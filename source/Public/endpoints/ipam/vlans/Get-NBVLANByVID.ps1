function Get-NBVLANByVID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$vid
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $VLANsAPIPath -field vid -value $vid).results

}