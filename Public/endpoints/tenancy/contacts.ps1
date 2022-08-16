Class NBContact {
	[string]$name
	#[int]$group
	# Constructor
	NBContact(
		[string]$name
	){
		$this.name = $name
		#$this.group = $null
	}
}
$ContactsAPIPath="tenancy/contacts"

function New-NBContact {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$Contact=[NBContact]::New($name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/"
		body = $Contact|ConvertTo-Json -Depth 50
	}
	Write-Verbose $Contact|ConvertTo-Json -Depth 50
	$Contact=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$Contact
}

function Get-NBContacts {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}

function Get-NBContact {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/$id/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Set-NBContact {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('group','name','title','phone','email','address',
			'link','comments')]
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
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBContact {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}