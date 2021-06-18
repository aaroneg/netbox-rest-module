class Site{
#region Properties    
    [ValidateNotNullOrEmpty()][string]$name
    [string]$slug
    [Validateset('planned','staging','active','decommissioning','retired')]
        [string]$status
    [int]$region
    [int]$tenant
    [string]$facility
    [int]$asn
    [string]$time_zone
    [string]$description
    [string]$physical_address
    [string]$shipping_address
    [decimal]$latitude
    [decimal]$longitude
    [string]$contact_name
    [string]$contact_phone
    [string]$contact_email
    [string]$comments
#endregion

    Site(
        [string]$name
    )
    {
        $this.name = $name
        $this.slug = $name.ToLower().Replace(' ','-')
    }
    Site(
        [string]$name,
        [string]$slug
    )
    {
        $this.name = $name
        $this.slug = $slug
    }

#region Methods
    #region Create method
    static [Site] Create(
        [string]$name,
        [string]$slug,
        [string]$status,
        [int]$region,
        [int]$tenant,
        [string]$facility,
        [int]$asn,
        [string]$time_zone,
        [string]$description,
        [string]$physical_address,
        [string]$shipping_address,
        [decimal]$latitude,
        [decimal]$longitude,
        [string]$contact_name,
        [string]$contact_phone,
        [string]$contact_email,
        [string]$comments
    )
    {
        $ArgumentString='dcim/sites/'
        $Body= @{name=$name}
        $Body+= @{slug=$name.ToLower().Replace(' ','-')}
        if($status){$Body+= @{status=$status}}
        $Body+= @{region=$region}
        $Body+= @{tenant=$tenant}
        if($facility){$Body+= @{facility=$facility}}
        $Body+= @{asn=$asn}
        if($facility){$Body+= @{time_zone=$time_zone}}
        if($facility){$Body+= @{description=$description}}
        if($facility){$Body+= @{physical_address=$physical_address}}
        if($facility){$Body+= @{shipping_address=$shipping_address}}
        $Body+= @{latitude=$latitude}
        $Body+= @{longitude=$longitude}
        if($facility){$Body+= @{contact_name=$contact_name}}
        if($facility){$Body+= @{contact_phone=$contact_phone}}
        if($facility){$Body+= @{contact_email=$contact_email}}
        if($facility){$Body+= @{comments=$comments}}
        # tags and custom_fields not supported.
        $restParams = @{
            Method               = 'post'
            Uri                  = "$($script:nbConnection.ApiBaseURL)$($ArgumentString)"
            SkipCertificateCheck = $script:nbConnection.SkipCertificateCheck
            Body=$Body
        }
        $return = Invoke-NbRequest -restParams $restParams
        if ($return) { return [Site]::Get($name) }
        else { return $false}
    }
    static [Object] Get(
        [string]$name
    )
    {
        $ArgumentString='dcim/sites/'
        $restParams = @{
            Method               = 'get'
            Uri                  = "$($script:nbConnection.ApiBaseURL)$($ArgumentString)"
            SkipCertificateCheck = $script:nbConnection.SkipCertificateCheck
        }
        $return = Invoke-NbRequest -restParams $restParams
        Write-Debug ($script:nbConnection|ConvertTo-Json)
        Write-Debug ($restParams|ConvertTo-Json)
        if ($return) { return $return.results }
        else { return $false}
    }
    hidden [void] set(
        [string]$name,
        [string]$slug,
        [string]$status,
        [int]$region,
        [int]$tenant,
        [string]$facility,
        [int]$asn,
        [string]$time_zone,
        [string]$description,
        [string]$physical_address,
        [string]$shipping_address,
        [decimal]$latitude,
        [decimal]$longitude,
        [string]$contact_name,
        [string]$contact_phone,
        [string]$contact_email,
        [string]$comments
    )
    {
        $ArgumentString='dcim/sites/'
        $Body= @{name=$name}
        $Body+= @{slug=$name.ToLower().Replace(' ','-')}
        if($status){$Body+= @{status=$status}}
        $Body+= @{region=$region}
        $Body+= @{tenant=$tenant}
        if($facility){$Body+= @{facility=$facility}}
        $Body+= @{asn=$asn}
        if($facility){$Body+= @{time_zone=$time_zone}}
        if($facility){$Body+= @{description=$description}}
        if($facility){$Body+= @{physical_address=$physical_address}}
        if($facility){$Body+= @{shipping_address=$shipping_address}}
        $Body+= @{latitude=$latitude}
        $Body+= @{longitude=$longitude}
        if($facility){$Body+= @{contact_name=$contact_name}}
        if($facility){$Body+= @{contact_phone=$contact_phone}}
        if($facility){$Body+= @{contact_email=$contact_email}}
        if($facility){$Body+= @{comments=$comments}}
        # tags and custom_fields not supported.
        $restParams = @{
            Method               = 'put'
            Uri                  = "$($script:nbConnection.ApiBaseURL)$($ArgumentString)"
            SkipCertificateCheck = $script:nbConnection.SkipCertificateCheck
            Body=$Body
        }
        Invoke-NbRequest -restParams $restParams|Out-Null
    }
    #endregion
#endregion
}
function Get-NbSite (){
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$name
    )
    [Site]::Get($name)
}
function New-NbSite {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$Connection=$Script:connection,
        [Parameter(Mandatory=$True)][string]$Name,
        [Parameter(Mandatory=$False)][string]$slug,
        [Parameter(Mandatory=$False)][switch]$whatif=$false
    )

    $Site=[Site]::New($Name)
    $Site

    # $SiteJson=$Site|ConvertTo-Json -Depth 100
    # if ($whatif) {
    #     $SiteJson
    # }
    # else {
    #     New-NbItem -Connection $Connection -RelativePath 'dcim/sites/' -JsonData $SiteJson
    # }
}

Export-ModuleMember -Function "*-*"