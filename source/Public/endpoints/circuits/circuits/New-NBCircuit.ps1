function New-NBCircuit {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$cid,
		[Parameter(Mandatory=$true,Position=1)][int]$provider,
		[Parameter(Mandatory=$false)][int]$provider_account,
		[Parameter(Mandatory=$true,Position=2)][int]$type,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('planned','provisioning','active','offline','deprovisioning','decommissioned')]
			$status,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][datetime]$install_date,
		[Parameter(Mandatory=$false)][datetime]$termination_date,
		[Parameter(Mandatory=$false)][int]$commit_rate,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][double]$distance,
		[Parameter(Mandatory=$false)][string][ValidateSet('km','m','mi','ft')]$distance_unit,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		# Not adding assignment support here, that's what those cmdlets are for
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	if($PSBoundParameters['install_date']) {$PSBoundParameters['install_date']=$PSBoundParameters['install_date']|Get-Date -Format 'yyyy-MM-dd'}
	if($PSBoundParameters['termination_date']) {$PSBoundParameters['termination_date']=$PSBoundParameters['termination_date']|Get-Date -Format 'yyyy-MM-dd'}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}