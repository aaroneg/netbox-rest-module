# There is almost certainly no point to this cmdlet since if you go from one termination type to another, you have to set both at the same time. 
# On the off chance it's useful I'll leave it in but if you have to switch types on one end of a termination, you're likely better off making a whole new termination.
function Set-NBCableTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('cable','cable_end','termination_type','termination_id')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBCableTerminationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}