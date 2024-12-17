function New-NBCableTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$cable,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('A','B')]
			$cable_end,		
		[Parameter(Mandatory=$false)][string]$termination_type,
		[Parameter(Mandatory=$false)][int]$termination_id,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCableTerminationsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}