function New-NBService {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][string]$parent_object_type,
		[Parameter(Mandatory=$false)][string]$parent_object_id,
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=0)][ValidateSet('tcp','udp','sctp')][string]$protocol,
		[Parameter(Mandatory=$true,Position=1)][int[]]$ports,
		[Parameter(Mandatory=$false)][int[]]$ipaddresses,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBServiceAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject
}