function Get-APIItemByQuery {
	[CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$field,
		[parameter(Mandatory = $true)][string]$value
    )
	$QueryArguments= @{
		$field = $value
	}
	$ArgumentString= New-ArgumentString $QueryArguments
    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/?$ArgumentString"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API search call using '$field' looking for '$value'."
    Invoke-CustomRequest $restParams -Connection $Connection
}
function Find-ApiItemsContainingName {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Name
    )
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Attempting to find items containing '$Name'."
    Get-APIItemByQuery -apiConnection $apiConnection -field 'name__ic' -value $value -RelativePath $RelativePath
}

function Get-APIItemByName {
	[CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
		[parameter(Mandatory = $true)][string]$value
    )
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Attempting to find item named '$Name'."
	Get-APIItemByQuery -apiConnection $apiConnection -field 'name' -value $value -RelativePath $RelativePath
}

function Get-ApiItemByID {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$id
    )
    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/$id/"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    Invoke-CustomRequest $restParams -Connection $Connection
}


function Get-ApiItems {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath
    )

    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
	# # (Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
    (Invoke-CustomRequest $restParams -Connection $apiConnection).results
}

#Export-ModuleMember -Function "*-*"