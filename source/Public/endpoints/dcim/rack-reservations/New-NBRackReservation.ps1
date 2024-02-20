function New-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$rack,
		[Parameter(Mandatory=$true,Position=1)]
			[ValidateRange(0,32767)]
			[int]$units,
		[Parameter(Mandatory=$true,Position=3)][int]$user,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$true,Position=4)][string]$description,
		[Parameter(Mandatory=$false)][int]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}