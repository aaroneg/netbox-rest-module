function Write-NBConfig {
	[CmdletBinding()]
	param (
		[Parameter(Position=0)][string]$TargetPath='.'
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Writing configuration file"
	# Create a config file
	$targetHostname=Read-Host -Prompt "IP address or hostname of Netbox server"
	$httpOnlyresp=Read-Host -Prompt "Is this netbox instance exclusively available over unencrypted http and not https? (y/n)"
	if ('y' -eq $httpOnlyresp)
		{
			$httpOnly=$true
		} 
		else {
			$httpOnly=$false
		}
	if($httpOnly){$SkipCertificateCheck=$true}
	else {
		$sscResponse=Read-Host -Prompt "Should we connect even if the certificate is not considered valid? (y/n)"
		if('y' -eq $sscResponse){$SkipCertificateCheck=$true}
		else {$SkipCertificateCheck=$false}
	}
	
	$config=@{
		serverAddress = $targetHostname
		httpOnly=$httpOnly
		skipCertificateCheck=$SkipCertificateCheck
	}
	$config
	$config | Export-Clixml $TargetPath\nbconfig.xml
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Wrote $($TargetPath)\nbconfig.xml - exiting"
}