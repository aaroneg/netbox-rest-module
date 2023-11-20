function New-NBASN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$asn,
		[Parameter(Mandatory=$true,Position=0)][int]$rir,
		[Parameter(Mandatory=$true,Position=0)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ASNsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}