$RacksAPIPath="dcim/racks"

function Get-NBRackElevation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/$id/elevation/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}
