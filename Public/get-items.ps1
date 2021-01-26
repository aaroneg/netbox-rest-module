function Get-NbItem {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$Connection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Field,
        [parameter(Mandatory = $true)][string]$Value
    )
    $ObjectAPIURI = "$($Connection.ApiBaseUrl)$($RelativePath)?"
    $Arguments = @{
        $Field = $Value
    }
    $Argumentstring = (New-ArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $Connection.SkipCertificateCheck
    }
    (Invoke-NbRequest $restParams).results
}

function Get-NbItems {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$Connection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath
    )
    $ObjectAPIURI = "$($Connection.ApiBaseUrl)$($RelativePath)?"
    $Arguments = @{
        
   }
    $Argumentstring = (New-ArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $Connection.SkipCertificateCheck
    }
    (Invoke-NbRequest $restParams).results
}

Export-ModuleMember -Function "*-*"