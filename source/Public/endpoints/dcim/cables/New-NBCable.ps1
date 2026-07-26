function New-NBCable {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)]
			[string]$type,
		[Parameter(Mandatory=$true,Position=0)][hashtable[]]$a_terminations,
		[Parameter(Mandatory=$true,Position=1)][hashtable[]]$b_terminations,
		[Parameter(Mandatory=$false)]
			[ValidateSet('connected','planned','decommissioning')]
			[string]$status,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][int]$length,
		[Parameter(Mandatory=$false)]
			[ValidateSet('km','m','cm','mi','ft','in')]
			[string]$length_unit,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCablesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}