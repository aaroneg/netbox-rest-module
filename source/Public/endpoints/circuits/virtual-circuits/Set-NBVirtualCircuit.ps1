function Set-NBVirtualCircuit {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('cid','provider','provider_account','type','status','tenant','install_date','termination_date','commit_rate','description','comments','tags')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualCircuitsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	$result = (Invoke-CustomRequest -restParams $restParams -Connection $Connection)
	if ($result.message) { $result.message }
	else { $result }

}