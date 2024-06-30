function Set-NBPowerFeed {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('power_panel','rack','name','status','type','supply','phase',
				'voltage','amperage','max_utilization','mark_connected','description','tenant',
				'comments','tags')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBPowerFeedsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}