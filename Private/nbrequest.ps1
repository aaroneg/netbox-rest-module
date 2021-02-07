function Invoke-NbRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][Object]$restParams
    )
    $Headers = @{
        "Authorization" = "Token $($script:nbConnection.ApiKey)"
        "Content-Type" = 'application/json'
        "Accept" = "application/json; indent=4"
    }
    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API call."
    try {
        $result = Invoke-RestMethod @restParams -Headers $headers #-ErrorAction Stop
    }
    catch {
#        if ($_.ErrorDetails.Message) {
#            Write-Error "Response from $($paConnection.Address): $(($_.ErrorDetails.Message|convertfrom-json).message)."
#        }
#        else {
            Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
            Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
            $_.ErrorDetails | ConvertTo-Json -Depth 100
 #       }
    }
    $result
}