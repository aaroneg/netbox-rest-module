function Set-NBVLAN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('site','group','vid','name','tenant','status',
			'role','description','qinq_role','qinq_svlan','owner',
			'comments','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}