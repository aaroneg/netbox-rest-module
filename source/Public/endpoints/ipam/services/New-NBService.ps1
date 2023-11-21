function New-NBService {
	<#
	.SYNOPSIS
	Adds a new service object to Netbox
	.PARAMETER device
	The id of the device object, if any
	.PARAMETER virtual_machine
	The id of the vm object, if any
	.PARAMETER name
	The name of the object
	.PARAMETER ports
	A list of ports the service listens to
	.PARAMETER protocol
	The protocol the service uses
	.PARAMETER ipaddresses
	The specific IP address IDs the service is bound to
	.PARAMETER description
	A description of the object.
	.PARAMETER comments
	Any comments you would like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][int]$device,
		[Parameter(Mandatory=$false)][int]$virtual_machine,
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int[]]$ports,
		[Parameter(Mandatory=$true,Position=2)][string]
			[ValidateSet('tcp','udp','sctp')]
			$protocol,
		[Parameter(Mandatory=$false)][int[]]$ipaddresses,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBServiceAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}