$servers=Get-Content"          "

foreach($server in $servers)
{
Write-Host "Processing the server $server "

Get-WmiObject  -Class Win32_Product -ComputerName $server | Select _SERVER , Name, Version -ErrorAction SilentlyContinue
}
