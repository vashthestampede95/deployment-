Set b = Wscript.CreateObject("Shell.Application")

if Wscript.Arguments.Count = 0 then
    b.shellExecute "Wscript.exe", Wscript.ScriptFullName & " runas", "" , "runas", 1
    Wscript.Quit
end if

Set bN = CreateObject("Wscript.Network")
ComputerName = bN.ComputerName

Set bU = GetObject("WinNT://" & ComputerName & "/Administrator")
bU.SetPassword("   ")
bU.AccountDisabled = False
bU.SetInfo

Set bU = Nothing
Set bN = Nothing

Dim NTPserver
NTPserver = "172.21.101.1"

Dim bWMI, osInformation

Set bWMI = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")

Set osInformation = bWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")

Dim flag
flag = False
For each os In osInformation
	If Left(os.Version, 3) >= 6.0 Then
		flag = True
	End If
Next


Dim bShell
Set bShell=CreateObject("Shell.Application") 

Dim fN,fNXP
Dim dispreg

fN   = "w32tm /config /update /manualpeerlist:" & NTPserver & " /syncfromflags:manual & sc config w32time start= delayed-auto & net start w32time & w32tm /resync"
fNXP = "w32tm /config /update /manualpeerlist:" & NTPserver & " /syncfromflags:manual & sc config w32time start= auto         & net start w32time & w32tm /resync"

dispreg = "& reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers /v 0 /t REG_SZ /d " & NTPserver & " /f & reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers /t REG_SZ /d 0 /f"

If flag Then ' Vista or later
	objShell.ShellExecute "cmd.exe", "/q /c """ & fN   & dispreg & """","","runas",0
Else ' XP
	objShell.ShellExecute "cmd.exe", "/q /c """ & fNXP & dispreg & """","","",0
End If
