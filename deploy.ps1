#For the organisational Key access defineing the parameters
 
#optional line command starting with first line

#Assigning parameters

param (
  [String]$acctkey,
  [String]$orgkey,
)

#Replacing ur account key with your key 

$AccountKey="__ACCOUNT_KEY__"

#Replacing organisatonal key with unique identifier 

$OrganisationalKey="__ORGANIZATION_KEY__"

#set to 1 for verbose logging 

$DebugPrintenabled=0

#Program begins 
####################################

#checking for account key on the command line 

if(![String]::IsNullOrEmpty($acctkey)){
  $AccountKey=$acctkey
}

#checking for organisational key on the command line
 
if(![String]::IsNullOrEmpty($orgkey)){
  $OrganisationalKey=$orgkey
}

#Variables defining for bit wise solution for windows station 
$X64=64
$X86=32
$InstallerName="    "
$InstallerPath=Join-Path $Env:$InstallerName
$VDUServicename="VDUAgent"
$DownloadURL = "               " + $AccountKey + "/" + $InstallerName
$ScriptFailed="Script Failed"

function Get-TimeStamp{
  return"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function Confirm-ServiceExists($service){
  if(Get-Service$service -ErrorAction SilentlyContinue){
    return true
    }
    return false
}
function Debug-Print($msg){
  if(DebugPrintenabled -eq 1){
    Write-Host "$(Get-TimeStamp)[DEBUG]$msg"
  }
}
function GetWindowsArchitecture{
  if ($env:ProgramW6432) {
        $WindowsArchitecture = $X64
    } else {
        $WindowsArchitecture = $X86
    }

    return $WindowsArchitecture
  
} 

function Get-Installer{
  Debug-Print("downloading installer...")
   $WebClient = New-Object System.Net.WebClient
   
   try {
       $WebClient.DownloadFile($DownloadURL, $InstallerPath)
   } catch {
       $ErrorMessage = $_.Exception.Message
       Write-Host "$(Get-TimeStamp) $ErrorMessage"
   }
   
      if ( ! (Test-Path $InstallerPath)) {
          $DownloadError = "Failed to download the Installer from $DownloadURL"
          Write-Host "$(Get-TimeStamp) $DownloadError"
          Write-Host "$(Get-TimeStamp) Verify you set the AccountKey variable to your account secret key."
          throw $ScriptFailed
      }
      Debug-Print("installer downloaded to $InstallerPath...")
  }
function Install-VDU($OrganizationalKey){
  Debug-Print("Checking for VDU Service if present ...")
  if(Confirm-ServiceExists($VDUServicename))
  $InstallerError = "The VDU Agent is already installed. Exiting."
      Write-Host "$(Get-TimeStamp) $InstallerError"
      exit 0
  }  
Debug-Print("Checking for the installer file")
if(!(Test-Path$InstallerPath)){
  $InstallerError="the installer was incorrectly removed from $InstallerPath"
  Write-Host"$(Get-TimeStamp)$InstallerError"
  Write-Host("$(Get-TimeStamp)A security product may have quarantined the installer. Please check " +
                               "your logs. If the issue continues to occur, please send the log to the VDU " +
                               "Team for help at Nippon Signal India,New Delhi")
  throw $ScriptFailed                             
}
Debug-Print("Executing Installer")
Start-Process $InstallerPath"/ACCTKEY=`$AccountKey`"/ORGKEY=`"$OrganisationalKey`"/s" -Wait 

function test-installation{
  Debug-Print("Verifying installation...")

    # Ensure we resolve the correct Huntress directory regardless of operating system or process architecture.
    $WindowsArchitecture = Get-WindowsArchitecture
    if ($WindowsArchitecture -eq $X86) {
        $VDUDirPath = Join-Path $Env:ProgramFiles "VDU"
    } elseif ($WindowsArchitecture -eq $X64) {
        $VDUPath = Join-Path $Env:ProgramW6432 "VDU"
    } else {
        $ArchitectureError = "Failed to determine the Windows Architecture. Received $WindowsArchitecure."
        Write-Host "$(Get-TimeStamp) $ArchitectureError"
        Write-Host "$(Get-TimeStamp) $SupportMessage"
        throw $ScriptFailed
    }

    $VDUAgentPath = Join-Path $VDUDirPath "VDUAgent.exe"
    $VDUUpdaterPath = Join-Path $VDUDirPath "VDUUpdater.exe"
    $WyUpdaterPath = Join-Path $HuntressDirPath "wyUpdate.exe"
    $VDUKeyPath = "HKLM:\SOFTWARE\     \VDU"
    $AccountKeyValueName = "AccountKey"
    $OrganizationKeyValueName = "OrganizationKey"
    $TagsValueName = "Tags"

    # Ensure the VDU installation directory was created.
    if ( ! (Test-Path $VDUDirPath)) {
        $VDUInstallationError = "The expected VDU directory $VDUDirPath did not exist."
        Write-Host "$(Get-TimeStamp) $VDUInstallationError"
        Write-Host "$(Get-TimeStamp) $SupportMessage"
        throw $ScriptFailed
    }
    
    # Ensure the VDU agent was created.
    if ( ! (Test-Path $VDUAgentPath)) {
        $VDUInstallationError = "The expected VDU agent $VDUAgentPath did not exist."
        Write-Host "$(Get-TimeStamp) $VDUInstallationError"
        Write-Host "$(Get-TimeStamp) $SupportMessage"
        throw $ScriptFailed
    }
    # Ensure the VDU updater was created.
   if ( ! (Test-Path $VDUUpdaterPath)) {
       $VDUInstallationError = "The expected VDU updater $VDUUpdaterPath did not exist."
       Write-Host "$(Get-TimeStamp) $VDUInstallationError"
       Write-Host "$(Get-TimeStamp) $SupportMessage"
       throw $ScriptFailed
   }
   #Ensure the wyupdate dependency created
   if ( ! (Test-Path $WyUpdaterPath)) {
       $HuntressInstallationError = "The expected wyUpdate dependency $WyUpdaterPath did not exist."
       Write-Host "$(Get-TimeStamp) $VDUInstallationError"
       Write-Host "$(Get-TimeStamp) $SupportMessage"
       throw $ScriptFailed
   }
   # Ensure the VDU registry key is present.
     if ( ! (Test-Path $VDUKeyPath)) {
         $VDURegistryError = "The expected VDU registry key '$VDUKeyPath' did not exist."
         Write-Host "$(Get-TimeStamp) $VDURegistryError"
         Write-Host "$(Get-TimeStamp) $SupportMessage"
         throw $ScriptFailed
     }
    $VDUKeyObject = Get-ItemProperty $VDUKeyPath
    # Ensure the VDU registry key is not empty.
        if ( ! ($VDUKeyObject)) {
            $VDURegistryError = "The VDU registry key was empty."
            Write-Host "$(Get-TimeStamp) $VDURegistryError"
            Write-Host "$(Get-TimeStamp) $SupportMessage"
            throw $ScriptFailed
        }

        # Ensure the AccountKey value is present within the VDU registry key.
        if ( ! (Get-Member -inputobject $VDUKeyObject -name $AccountKeyValueName -Membertype Properties)) {
            $HuntressRegistryError = ("The expected VDU registry value $AccountKeyValueName did not exist " +
                                      "within $VDUKeyPath")
            Write-Host "$(Get-TimeStamp) $VDURegistryError"
            Write-Host "$(Get-TimeStamp) $SupportMessage"
            throw $ScriptFailed
        }
        # Ensure the OrganizationKey value is present within the VDU registry key.
if ( ! (Get-Member -inputobject $VDUKeyObject -name $OrganizationKeyValueName -Membertype Properties)) {
    $VDURegistryError = ("The expected VDU registry value $OrganizationKeyValueName did not exist " +
                              "within $VDUKeyPath")
    Write-Host "$(Get-TimeStamp) $VDURegistryError"
    Write-Host "$(Get-TimeStamp) $SupportMessage"
    throw $ScriptFailed
}

# Ensure the Tags value is present within the VDU registry key.
if ( ! (Get-Member -inputobject $VDUKeyObject -name $TagsValueName -Membertype Properties)) {
    $VDURegistryError = ("The expected VDU registry value $TagsKeyValueName did not exist within " +
                              "$VDUKeyPath")
    Write-Host "$(Get-TimeStamp) $VDURegistryError"
    Write-Host "$(Get-TimeStamp) $SupportMessage"
    throw $ScriptFailed
}

Debug-Print("Installation verified...")
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

# make sure we have an org key (either hard coded or from the command line params)
if ($OrganizationKey -eq "__ORGANIZATION_KEY__") {
    Write-Warning "$(Get-TimeStamp) OrganizationKey not specified, exiting script!"
    exit 1
}

Write-Host "$(Get-TimeStamp) OrganizationKey: " $OrganizationKey
Get-Installer
Install-VDU $OrganizationKey
Test-Installation
Write-Host "$(Get-TimeStamp) VDU Agent successfully installed"
}

try
{
main
} catch {
$ErrorMessage = $_.Exception.Message
Write-Host "$(Get-TimeStamp) $ErrorMessage"
exit 1
}
}

