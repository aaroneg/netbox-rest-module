function Set-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('address','vrf','tenant','status','role','nat_inside','dns_name','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}