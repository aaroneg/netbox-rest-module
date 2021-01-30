class Circuit {
    [string]$cid
    [int]$provider
    [int]$type
    [string]$status
    [int]$tenant
    [datetime]$install_date
    [int]$commit_rate
    [string]$description
    [string]$comments
    [array]$tags
    [hashtable]$custom_fields
}
Export-ModuleMember -Function "*-*"