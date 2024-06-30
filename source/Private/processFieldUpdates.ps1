function processFieldUpdates($key,$value) {
	switch($key){
		'slug' {$value=makeSlug -name $value}
		'tags' {[array]$value=$value.Split(',')}
		'install_date' {$value = $value|Get-Date -Format 'yyyy-MM-dd'}
		'termination_date' {$value = $value|Get-Date -Format 'yyyy-MM-dd'}
		'ipaddresses' {[array]$value=$value.Split(',')}
		default {}
	}
	$update=@{
		$key = $value
	}
	$update
}