@echo off

rem basic organisation acces key and basic username 

 set ACCTKEY=__ACCOUNT_KEY__

 set POWERSHELL=powershell

if exist %SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe (
    set POWERSHELL=%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe
)

%POWERSHELL% -executionpolicy bypass -f ./() -acctkey %ACCTKEY% -orgkey %1
