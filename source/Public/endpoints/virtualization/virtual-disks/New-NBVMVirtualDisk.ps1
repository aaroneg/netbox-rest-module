function New-NBVMVirtualDisk {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$virtual_machine,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$true,Position=2)][int]$size,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if (!($PSBoundParameters.ContainsKey('status'))) {$PSBoundParameters.add('status', $status)}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualDisksAPIPath/"
		body = $PostJson
	}
	$PostObject= Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
