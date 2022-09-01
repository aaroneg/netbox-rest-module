Class NBIPRange {
	[string]$start_address
	[string]$end_address
	[string]$status

	# Constructor
	NBIPRange(
		[string]$start_address,
		[string]$end_address,
		[string]$status
	){
		$this.start_address = $start_address
		$this.end_address = $end_address
		$this.status = $status
	}
}
$IPRangesAPIPath="ipam/ip-ranges"

function New-NBIPRange {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$startAddress,
		[Parameter(Mandatory=$true,Position=1)][string]$endAddress,
		[Parameter(Mandatory=$true,Position=2)][string][ValidateSet('active','reserved','deprecated')]$status,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBIPRange]::New($startAddress,$endAddress,$status)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$IPRangesAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBIPRanges {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $IPRangesAPIPath
}

function Get-NBIPRangeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $IPRangesAPIPath -id $id
}

function Get-NBIPRangeByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $IPRangesAPIPath -value $name
}


function Set-NBIPRange {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('start_address','end_address','vrf','tenant','status','role','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPRangesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBIPRange {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$IPRangesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
