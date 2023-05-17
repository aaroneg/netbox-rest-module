Class NBIPAddress {
	[string]$address

	# Constructor
	NBIPAddress(
		[string]$address

	){
		$this.address = $address
	}
}
$IPAddressAPIPath="ipam/ip-addresses"

function New-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$address,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$PostObject=[NBIPAddress]::New($address)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject
}

function Get-NBIPAddresses {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItems -apiConnection $Connection -RelativePath $IPAddressAPIPath
}

function Get-NBIPAddressByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItemByID -apiConnection $Connection -RelativePath $IPAddressAPIPath -id $id
}

function Get-NBIPAddressByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItemByName -apiConnection $Connection -RelativePath $IPAddressAPIPath -value $name
}


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
function Remove-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
