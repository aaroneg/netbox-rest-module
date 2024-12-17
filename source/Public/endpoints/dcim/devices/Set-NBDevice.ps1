function Set-NBDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		# ValidateSets updated as of Netbox v4.1.8
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','device_type','role','tenant','platform','serial','asset_tag','site',
				'location','rack','position','face','latitude','longitude','status','airflow','primary_ip4',
				'primary_ip6','oob_ip','cluster','virtual_chassis','vc_position','vc_priority','description',
				'comments','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$DevicesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	Write-Debug $restParams.body|Out-String
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}