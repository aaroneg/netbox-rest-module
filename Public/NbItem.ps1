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

function New-NbItem {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$Connection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $false)][object]$Arguments,
        [parameter(Mandatory = $true)][object]$JsonData,
        [Parameter(Mandatory=$False)][switch]$whatif=$false
    )
    $ObjectAPIURI = "$($Connection.ApiBaseUrl)$($RelativePath)?"
    $Arguments = @{
        
    }
     $Argumentstring = (New-ArgumentString $Arguments)
     $restParams = @{
         Method               = 'post'
         Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
         SkipCertificateCheck = $Connection.SkipCertificateCheck
         Body = $JsonData
     }
     if ($whatif) {
        Write-Host "Would write the following JSON to $($ObjectAPIURI):"
        $restParams.Body
     }
     else {
        Invoke-NbRequest $restParams
     }
     
}

function Set-NbItem {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$Connection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $false)][object]$Arguments,
        [parameter(Mandatory = $true)][object]$Data
    )
    $ObjectAPIURI = "$($Connection.ApiBaseUrl)$($RelativePath)?"
    $Arguments = @{
        
    }
     $Argumentstring = (New-ArgumentString $Arguments)
     $restParams = @{
         Method               = 'post'
         Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
         SkipCertificateCheck = $Connection.SkipCertificateCheck
         Body = @{data=$Data}
     }
     (Invoke-NbRequest $restParams).results
}

Export-ModuleMember -Function "*-*"