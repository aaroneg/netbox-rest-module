function New-NBPowerFeed {
	<#
	.SYNOPSIS
	Adds a new device object to Netbox
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=1)][int]$power_panel,
		[Parameter(Mandatory=$false)][int]$rack,
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('offline','active','planned','failed')]
			$status,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('primary','redundant')]
			$type,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('ac','dc')]
			$supply,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('single-phase','three-phase')]
			$phase,
		[Parameter(Mandatory=$false)][int]$voltage,
		[Parameter(Mandatory=$false)][int]$amperage,
		[Parameter(Mandatory=$false)][int]$max_utilization,
		[Parameter(Mandatory=$false)][bool]$mark_connected,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if($PSBoundParameters['mark_connected']) {$PSBoundParameters['mark_connected']=[System.Boolean]$true}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBPowerFeedsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}