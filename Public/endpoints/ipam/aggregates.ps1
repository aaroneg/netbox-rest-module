Class NBAggregate {
	[string]$prefix
	[string]$rir
	# Constructor
	NBAggregate(
		[string]$prefix,
		[string]$rir
	){
		$this.prefix = $prefix
		$this.rir = $rir
	}
}
$NBAggregateAPIPath="ipam/aggregates"

function New-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$prefix,
		[Parameter(Mandatory=$true,Position=1)][string]$rirID,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBAggregate]::New($prefix,$rirID)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBAggregates {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBAggregateAPIPath
}

function Get-NBAggregateByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBAggregateAPIPath -id $id
}

function Get-NBAggregateByPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$prefix
	)
	Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBAggregateAPIPath -field prefix -value $prefix
}

function Set-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('prefix','rir','tenant','date_added','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
