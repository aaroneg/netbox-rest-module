function Get-ApiItem {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Name
    )
    $ObjectAPIURI = "$($apiConnection.ApiBaseUrl)$($RelativePath)?"
    $Arguments = @{
        location = $Location
        name = $Name
    }
    $Argumentstring = (New-ArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    (Invoke-CustomRequest $restParams).result.entry
}

function Get-ApiItems {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath
    )
    $ObjectAPIURI = "$($apiConnection.ApiBaseUrl)$($RelativePath)?"

    $Arguments = @{
        location = $Location
        name = $Name
    }

    $Argumentstring = (New-ArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    (Invoke-CustomRequest $restParams).result.entry
}

#Export-ModuleMember -Function "*-*"