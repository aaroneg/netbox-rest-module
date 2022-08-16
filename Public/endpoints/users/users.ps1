# Class NBUser {
# 	[string]$username
# 	[string]$password
# 	# Constructor
# 	NBUser(
# 		[string]$username,
# 		[string]$password
# 	){
# 		$this.username = $username
# 		$this.password = $password
# 	}
# }
$UsersAPIPath="users/users"

# function New-NBUser {
# 	[CmdletBinding()]
# 	param (
# 		[Parameter(Mandatory=$true,Position=0)][string]$username,
# 		[Parameter(Mandatory=$true,Position=1)][string]$password,
# 		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
# 	)
# 	$User=[NBUser]::New($username,$password)
# 	$restParams=@{
# 		Method = 'Post'
# 		URI = "$($Connection.ApiBaseURL)/$UsersAPIPath/"
# 		body = $User|ConvertTo-Json -Depth 50
# 	}
# 	Write-Verbose $User|ConvertTo-Json -Depth 50
# 	$User=Invoke-CustomRequest -restParams $restParams -Connection $Connection
# 	$User
# }

function Get-NBUsers {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$UsersAPIPath/"
	}
	$restParams.URI
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}

function Get-NBUser {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$UsersAPIPath/$id/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

# function Set-NBUser {
# 	[CmdletBinding()]
# 	param (
# 		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
# 		[Parameter(Mandatory=$true,Position=0)][int]$id,
# 		[Parameter(Mandatory=$true,Position=1)][string]
# 			[ValidateSet('name','slug','status','region','group','tenant','facility','time_zone','description','physical_address','shipping_address','latitude','longitude','comments')]
# 			$key,
# 		[Parameter(Mandatory=$true,Position=2)][string]$value
# 	)
# 	switch($key){
# 		'slug' {$value=makeSlug -name $value}
# 		default {}
# 	}
# 	$update=@{
# 		$key = $value
# 	}
# 	$restParams=@{
# 		Method = 'Patch'
# 		URI = "$($Connection.ApiBaseURL)/$UsersAPIPath/$id/"
# 		body = $update | ConvertTo-Json -Depth 50
# 	}
# 	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
# }

# function Remove-NBUser {
# 	[CmdletBinding()]
# 	param (
# 		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
# 		[Parameter(Mandatory=$true,Position=0)][int]$id
# 	)
# 	$restParams=@{
# 		Method = 'Delete'
# 		URI = "$($Connection.ApiBaseURL)/$UsersAPIPath/$id/"
# 		body = $update | ConvertTo-Json -Depth 50
# 	}
# 	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
# }