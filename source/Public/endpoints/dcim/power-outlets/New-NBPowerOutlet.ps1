function New-NBPowerOutlet {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$device,
		[Parameter(Mandatory=$false)][int]$module,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$false)]
			# Not going to enumerate every possible value here, there are too many.
			[string]$type,
		[Parameter(Mandatory=$false)]
			[ValidateSet('enabled','disabled','faulty')]
			[string]$status,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][hashtable]$power_port,
		[Parameter(Mandatory=$false)]
			[ValidateSet('A','B','C')]
			[string]$feed_leg,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][bool]$mark_connected,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBPowerOutletsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}