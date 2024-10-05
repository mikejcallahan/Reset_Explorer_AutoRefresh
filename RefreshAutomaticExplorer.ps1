Write-Output '------------------------------------------------------------------------'
Write-Output '//////////////// Fixes Explorer not auto-refreshing \\\\\\\\\\\\\\\\\\\\'
write-output '//////////////// User is logged off. Gain access b4 \\\\\\\\\\\\\\\\\\\\'
Write-Output '------------------------------------------------------------------------'

function testElevation {
 <#-----------------------------------------------------------------
 .DESCRIPTION
 Checks currentUser role. Evaluates false if not running as admin
 -------------------------------------------------------------------#>
 param([switch]$Elevated)
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} 

<#------[script body args]---------------
Relaunches as admin then starts calling sequence.
-------------------------------------------------#>
if (!(testElevation)){if ($elevated) {write-host 'elevation confirmed'} else {
 try {Start-Process powershell.exe -Verb RunAs -erroraction stop -ArgumentList (' -noprofile -ExecutionPolicy bypass -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}catch {read-host `r`n "Elevation Required." `r`n} exit }}
#--------------------------------------------------------------------


#Main commands
$User = Read-Host -Prompt 'username'

$Path = 'c:\Users\' + $User + '\AppData\Local\Microsoft\Windows\Explorer\'

Set-Location -path $Path

Get-ChildItem -Path $Path -File -Filter 'iconcache*' | Remove-Item
Get-ChildItem -Path $Path -File -Filter 'thumbcache*' | Remove-Item

get-childitem 

pause