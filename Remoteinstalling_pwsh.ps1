param([String]$acctkey,
      [String]$orgkey
)
$acctkey="_ACCOUNT_KEY_"
$orgKey ="_ORGANISATION_KEY_"

$Debugprintenabled=0


$servers= Get-Content"         "

$source="           "

$dest="             "

$testPath="         " 


if(![String]::IsNullOrEmpty($acctkey)&![String]::IsNullOrEmpty($orgkey))
{
$OrganisationKey=$orgKey
$Accountkey=$acctkey 
foreach($server in $servers)
{
if(test-Connection -Cn $computer -quiet)
 { 
  Copy-item $source -Destination \\$computer\$dest -Recurse -Force
  
  if(TestPath -Path $testPath)
  {
   Invoke-Command -ComputerName $server -ScriptBlock{powershell.exe  c:\install\hascats.exe /sALl / msi /norestart ALLUSERS=1 EULA_ACCEPT=yes}            }
   Write-Host -ForegroundColor Green "Installation Successful on $server"
   }
  }else{
        Write-Host -ForegroundColor Red "$Server is not online ,Installation failed"
        }
  }      
  }
  function Get-TimeStamp{
  return"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}
function main(){
  #make sure the account key 
  Debug-Print("Checking for Account Key")
  if ($AccountKey -eq "__ACCOUNT_KEY__") {
    Write-Warning "$(Get-TimeStamp) AccountKey not set, exiting script!"
    exit 1
} elseif ($AccountKey.length -ne 32) {
    Write-Warning "$(Get-TimeStamp) Invalid AccountKey specified, exiting script!"
    exit 1
}
