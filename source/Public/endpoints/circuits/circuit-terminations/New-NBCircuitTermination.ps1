function New-NBCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$circuit,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('A','Z')]
			$term_side,		
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$provider_network,
		[Parameter(Mandatory=$false)][int]$port_speed,
		[Parameter(Mandatory=$false)][int]$upstream_speed,
		[Parameter(Mandatory=$false)][string]$xconnect_id,
		[Parameter(Mandatory=$false)][string]$pp_info,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][bool]$mark_connected,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTerminationsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}