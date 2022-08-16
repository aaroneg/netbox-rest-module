# Class NBRackReservation {
# 	[int]$rack
# 	[string]$units
# 	[array]$user
# 	[string]$description
# 	# Constructor
# 	NBRackReservation(
# 		[int]$rack,
# 		[array]$units,
# 		[int]$user,
# 		[string]$description

# 	){
# 		$this.rack = $rack
# 		$this.units = $units
# 		$this.user = $user
# 		$this.description = $description
# 	}
# }
$RackReservationsAPIPath="dcim/rack-reservations"

# function New-NBRackReservation {
# 	[CmdletBinding()]
# 	param (
# 		[Parameter(Mandatory=$true,Position=0)][int]$rackid,
# 		[Parameter(Mandatory=$true,Position=1)][array]$units,
# 		[Parameter(Mandatory=$true,Position=3)][int]$user,
# 		[Parameter(Mandatory=$true,Position=4)][string]$description,
# 		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
# 	)
# 	$RackReservation=[NBRackReservation]::New($rackid,$units,$user,$description)
# 	$restParams=@{
# 		Method = 'Post'
# 		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/"
# 		body = $RackReservation|ConvertTo-Json -Depth 50
# 	}
# 	$RackReservation|ConvertTo-Json -Depth 50
# 	$RackReservation=Invoke-CustomRequest -restParams $restParams -Connection $Connection
# 	$RackReservation
# }

function Get-NBRackReservations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $RackReservationsAPIPath
}

function Get-NBRackReservationByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $RackReservationsAPIPath -id $id
}

function Set-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','status','region','group','tenant','facility','time_zone','description','physical_address','shipping_address','latitude','longitude','comments')]
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
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}