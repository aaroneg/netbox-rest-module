class Site{
    [string]$name
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

    Site(
        [string]$n
    )
    {
        $this.name=$n
        $this.slug=$n.ToLower().Replace(' ','-')
    }
    Site() {}
}
function New-NbSite {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][object]$Connection=$Script:connection,
        [Parameter(Mandatory=$True)][Site]$Site,
        [Parameter(Mandatory=$False)][switch]$whatif=$false
    )

    $SiteJson=$Site|ConvertTo-Json -Depth 100
    if ($whatif) {
        $SiteJson
    }
    else {
        New-NbItem -Connection $Connection -RelativePath 'dcim/sites/' -JsonData $SiteJson
    }
}

Export-ModuleMember -Function "*-*"