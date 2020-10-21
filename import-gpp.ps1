# This script is to import GPO conveniently #
#.EXAMPLE
#C:\PS>import-gpp.ps1 -Domain www.microsoft.com  -Drive C:\BackGPO
#Get the specified parameters#
    Param
    (
        $Domain,
        $Drive
    )

$Temp1 = $Domain.split(".")

foreach($f in $Temp1)
{
    $DC= $DC  + "dc=$f,"
}

$DC=$DC.Trim(",")

Get-WindowsFeature -Name GPMC   #Install Group Policy Management Features#

mkdir $Drive                  #New Folder #

Backup-Gpo -All -Path $Drive   #Back up the current domain GPO to Drive #

New-GPO -Name "Agent-GPP"             #New name is Agent-GPPGOP#

import-gpo -BackupId 7F1493CA-E0E1-45F0-A0DA-D83392C96F8D -TargetName Agent-GPP -path c:\Agent-GPP -CreateIfNeeded #Import GPO#

New-GPLink -Name "Agent-GPP"-Domain $Domain -Target "ou=domain controllers,$DC" -Order 1 #Create a new GPO to connect to domain controllers and set the priority to 1#

gpupdate /force #Mandatory update of GPO#