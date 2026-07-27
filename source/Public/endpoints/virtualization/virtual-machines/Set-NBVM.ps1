function Set-NBVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','virtual_machine_type','role','status','start_on_boot','site','cluster','device',
			'platform','primary_ip4','primary_ip6','vcpus','memory','disk','description','serial','tenant',
			'owner','comments','tags','local_context_data','config_template','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	Write-Debug ($restParams.body|Out-String)
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}