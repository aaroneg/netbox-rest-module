function New-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$prefix,
		[Parameter(Mandatory=$true,Position=1)][int]$rir,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$date_added,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}