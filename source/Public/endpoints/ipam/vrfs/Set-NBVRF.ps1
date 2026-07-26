function Set-NBVRF {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','rd','tenant','enforce_unique','description','owner','comments','import_targets','export_targets','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VRFsApiPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}

# TODO: allow import/export targets to be set in new functions or parameter sets here