#requires -version 2
########################################################
#
# This script is to import AgentGPO conveniently
# powershell   by Pig
#
########################################################
function import-AgentGPO
{
<#
    .Precautions
        Spaces need to be enclosed in quotation marks
    .GPOPath
        The path of the GPO to be imported
    .BackUpDrive
    Save path of GPO to be backed up
    .EXAMPLE
        C:\PS>import-gpp.ps1 -Domain subdomain.domain.com  -GPOPath  C:\Agent -BackUpDrive C:\BackGPO
#>
[CmdletBinding()]
    Param 
        (
            [String]
            $Domain,
            [String]
            $BackUpDrive,
            [String]
            $GPOPath
        )
    #Get the specified parameters 
    Import-GPO   $Domain $BackUpDrive  $Drive

#Start to import GPO formally
function Import-GPO
{
    $Temp1 = $Domain.split(".")
    foreach($f in $Temp1)
        {
            $DC=$DC  + "dc=$f,"
        }
    $DC=$DC.Trim(",")
    #Install Group Policy Management Features
    try
        {
            import-module GroupPolicy
        }
    catch
        {
            Get-WindowsFeature -Name GPMC
            exit 1
        }
    #New Folder #
    mkdir $Drive

    #Back up the current domain GPO to Drive
    Backup-Gpo -All -Path $Drive

    #New name is Agent-GPPGOP
    New-GPO -Name "Agent-GPP"

    #Import GPO
    import-gpo -BackupId 7F1493CA-E0E1-45F0-A0DA-D83392C96F8D -TargetName Agent-GPP -path $BackUpDrive -CreateIfNeeded

    #Create a new GPO to connect to domain controllers and set the priority to 1
    New-GPLink -Name "Agent-GPP" -Domain $Domain -Target "ou=domain controllers,$DC" -Order 1

    #Mandatory update of GPO
    gpupdate /force
}
}
