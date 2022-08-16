function Find-ApiItemsByName {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Name
    )
	$QueryArguments= @{
		name__ic = $Name
	}
	$ArgumentString= New-ArgumentString $QueryArguments
    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/?$ArgumentString"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    (Invoke-CustomRequest $restParams -Connection $Connection).results
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