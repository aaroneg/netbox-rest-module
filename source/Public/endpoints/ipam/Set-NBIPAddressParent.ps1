function Set-NBIPAddressParent {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('dcim.interface','virtualization.vminterface')]
			$InterFaceType,
		[Parameter(Mandatory=$true,Position=2)][string]$interface
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$update=@{
		assigned_object_type = "$InterFaceType"
		assigned_object_id = $interface
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}