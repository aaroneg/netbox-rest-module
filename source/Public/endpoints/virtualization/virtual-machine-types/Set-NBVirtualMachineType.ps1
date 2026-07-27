function Set-NBVirtualMachineType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','default_platform','default_vcpus','default_memory','description','owner',
			'comments','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMTypesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	Write-Debug ($restParams.body|Out-String)
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}