<#
.DESCRIPTION
This script updates an app group users based on a Windows AD security gorup
Tested with Windows AD only, not Azure AD
.PARAMETER adGroupName
Specifies the source group that the WVD App Group will update from.
.PARAMETER wvdTenantName
Specifies the Tenant name for the WVD service.
.PARAMETER wvdHostPoolName
Specifies the Host Pool name for the WVD service.
.PARAMETER wvdAppGroupName
Specifies the App Group users are added to.
.NOTES
Script is offered as-is with no warranty
Test it before you trust it
Author      : Travis Roberts
Website     : www.ciraltos.com
Version     : 1.0.0.0 Initial Build
#>

[CmdletBinding()]
param (
    [Parameter (Mandatory = $true)]
    [string] $adGroupName,
    [Parameter (Mandatory = $true)]
    [string] $wvdTenantName,
    [Parameter (Mandatory = $true)]
    [string] $wvdHostPoolName,
    [Parameter (Mandatory = $true)]
    [string] $wvdAppGroupName
)

# Verify WVD and AD module
$reqModule = @('ActiveDirectory', 'Microsoft.RDInfra.RDPowershell')
foreach ($module in $reqModule) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module
        Write-Host "Module $module imported"
    }
    else {
        Write-Host "Module $module does not exist.  Install module and try again" -ForegroundColor Red
        exit
    }
}

# Verify the user is logged in
$rdsContext = get-rdscontext -ErrorAction SilentlyContinue
if ($rdsContext -eq $null) {
    try {
        Write-host "Use the login window to connect to WVD" -ForegroundColor Red
        Add-RdsAccount -ErrorAction Stop -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
    }
    catch {
        $ErrorMessage = $_.Exception.message
        write-host ('Error logging into the WVD account ' + $ErrorMessage)
        exit
    }
}

# Create user list and target list array
$adGroupUsers = @()
$appGroupUsers = @()

# Get the list of AD Group and WVD App Group users
    $adGroupUsers = (Get-ADGroupMember -identity $adGroupName -Recursive -Server auburn.edu | ForEach-Object { Get-ADUser -Server auburn.edu $_.SamAccountName } | Select-Object userPrincipalName).userPrincipalName
    $appGroupUsers = (Get-RdsAppGroupUser -TenantName $wvdTenantName -HostPoolName $wvdHostPoolName -AppGroupName $wvdAppGroupName).UserPrincipalName
# Logic to check if source users are part of the target group, add them if not
foreach ($adGroupUser in $adGroupUsers) {
    # If user is in the AD Group and the App group, do nothing
    if ($appGroupUsers -contains $adGroupUser) {
        Write-Host ("$adGroupUser was found in the targetUsers list")
    }
    # If user is in the AD Group and not in the WVD App Group, add them
    elseif ($appGroupUsers -notcontains $adGroupUser) {
        try {
            Add-RdsAppGroupUser -ErrorAction Stop -TenantName $wvdTenantName -HostPoolName $wvdHostPoolName -AppGroupName $wvdAppGroupName -UserPrincipalName $adGroupUser
            Write-Host ("$adGroupUser not found in $wvdAppGroupName, adding to App Group $wvdAppGroupName")
        }
        Catch {
            $ErrorMessage = $_.Exception.message
            Write-Host ("Error adding user $adGroupUser to the target group. Message:" + $ErrorMessage)
        }
    }
}

