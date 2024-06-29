function Get-NBCircuitByCID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$cid
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBCircuitsAPIPath -field cid -value $cid).results

}