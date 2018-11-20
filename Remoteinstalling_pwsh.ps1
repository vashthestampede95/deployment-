$servers= Get-Content"         "

$source="           "

$dest="             "

$testPath="         " 

foreach($server in $servers)
{
if(test-Connection -Cn $computer -quiet)
 { 
  Copy-item $source -Destination \\$computer\$dest -Recurse -Force
  
  if(TestPath -Path $testPath)
  {
   Invoke-Command -ComputerName $server -ScriptBlock{powershell.exe               }
   Write-Host -ForegroundColor Green "Installation Successful on $server"
   }
  }else{
        Write-Host -ForegroundColor Red "$Server is not online ,Installation failed"
        }
  }      