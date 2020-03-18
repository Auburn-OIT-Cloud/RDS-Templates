 # WVD group sync tool
 
_WVD_Group_SYNC_ Adds users in the AD group specified and removes user from the AppPool who are not in the AD group
 _WVD_Group_SYNC_ Adds users in the AD group specified but dose not remove users
### Prerequs 
  * ActiveDirectory Powershell Module installed `Install-module -name activedirectory`
        *This requires RSAT Tools to be installed*
  * Windows Virtural Desktop Powershell module installed `Install-Module -Name Microsoft.RDInfra.RDPowerShell`    
### Examples

```powershell
.\WVD_Group_SYNC.ps1 -adGroupName "AdGroup" `
 -wvdTenantName "TenantName" `
 -wvdHostPoolName "Hostpoolname" `
 -wvdAppGroupName "AppGroupName"
 ```
 ```powershell
.\WVD_Group_SYNC_No_Removal.ps1 -adGroupName "AdGroup" `
 -wvdTenantName "TenantName" `
 -wvdHostPoolName "Hostpoolname" `
 -wvdAppGroupName "AppGroupName"
 ```

