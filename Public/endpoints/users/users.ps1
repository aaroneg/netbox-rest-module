$UsersAPIPath="users/users"

function Get-NBUsers {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $UsersAPIPath
}

function Get-NBUserByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $UsersAPIPath -id $id
}

function Get-NBUserByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $UsersAPIPath -value $name
}

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
