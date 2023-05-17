Class NBVLAN {
	[int]$vid
	[string]$name
	[string]$status
	[int]$site
	# [int]$group
	[int]$tenant
	# [int]$role
	# [string]$description
	# Constructor
	NBVLAN(
		[int]$vid,
		[string]$name,
		[string]$status
	){
		$this.vid = $vid
		$this.name = $name
		$this.status = $status
	}
}
$VLANsAPIPath="ipam/vlans"

function New-NBVLAN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$vid,
		[Parameter(Mandatory=$true,Position=2)]
			[ValidateSet('active','reserved','deprecated')]
			[string]$status,
		[Parameter(Mandatory=$false)][int]$siteID,
		[Parameter(Mandatory=$false)][int]$groupID,
		[Parameter(Mandatory=$false)][int]$tenantID,
		[Parameter(Mandatory=$false)][int]$roleID,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBVLAN]::New($vid,$name,$status)
	if($siteID) {$PostObject.site = $siteID}
	if($groupID) {
		$PostObject | Add-Member -MemberType NoteProperty -Name group -Value $groupID 
	}
	if($tenantID) {$PostObject.tenant = $tenantID}
	if($roleID) {$PostObject.role = $roleID}
	if($description) {$PostObject.description = $description}
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject
}

function Get-NBVLANs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VLANsAPIPath
}

function Get-NBVLANByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VLANsAPIPath -id $id
}

function Get-NBVLANByVID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$vid
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $VLANsAPIPath -field vid -value $vid).results
}

function Get-NBVLANByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VLANsAPIPath -value $name
}

function Find-NBVLANsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VLANsAPIPath -name $name
}

function Set-NBVLAN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('site','group','vid','name','tenant','status',
			'role','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBVLAN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
