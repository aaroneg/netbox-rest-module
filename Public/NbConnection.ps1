<#
.SYNOPSIS
    Creates a connection object
.PARAMETER DeviceAddress
    The address of your API. This is a DNS or IP address. All of the rest of the URL is generated for you.
.PARAMETER ApiKey
    Your API key.
.PARAMETER Passthru
    Set this to true to get a copy of the Connection Object.
.EXAMPLE
    PS> New-nbConnection -DeviceAddress 192.168.1.2 -ApiKey abcd
.INPUTS
    None. This cmdlet does not support pipelines.
.OUTPUTS
    System.Object
#>
function New-NbConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][string]$DeviceAddress,
        [Parameter(Mandatory=$True,Position=1)][string]$ApiKey,
        [Parameter(Mandatory=$false)][bool]$SkipCertificateCheck=$True,
        [Parameter(Mandatory=$false)][switch]$Passthru
    )
    $ConnectionProperties = @{
        Address    = "$DeviceAddress"
        ApiKey     = $ApiKey
        ApiBaseURL = "https://$DeviceAddress/api/"
    }
    $Connection = New-Object psobject -Property $ConnectionProperties
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($Connection.Address)' is now the default connection."
    $Script:Connection=$Connection
    if ($Passthru){
        $Connection
    }
    
}

<#
.SYNOPSIS
    Tests a Connection object
.PARAMETER Connection
    A connection object from New-nbConnection
.EXAMPLE
    PS> Test-nbConnection $nbConnection
.INPUTS
    System.Object
.OUTPUTS
    System.String
#>
function Test-NbConnection {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,Mandatory=$True,Position=0)][object]$Connection
    )
    Write-Output "User list:"
    Get-NbItems -RelativePath 'users/users/'|Select-Object -Property id,username,is_staff,is_active|Write-Output
    Write-Output "`nPrinting results for user 1:`n"
    Get-NbItem -RelativePath 'users/users/' -Field 'id' -Value '1'
}

function Get-NbCurrentConnection {
    "Here is the current default connection:"
    $Script:Connection
}

Export-ModuleMember -Function "*-*"