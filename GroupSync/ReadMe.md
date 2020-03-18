
# AD Group Sync Tools 
### WVD_Group_SYNC Adds users in the AD group specified and removes user from the AppPool who are not in the AD group
### WVD_Group_SYNC Adds users in the AD group specified but dose not remove users

### Examples
```powershell
.\WVD_Group_SYNC.ps1 -adGroupName "AdGroup" `
 -wvdTenantName "TenantName" `
 -wvdHostPoolName "Hostpoolname" `
 -wvdAppGroupName "AppGroupName"
```
