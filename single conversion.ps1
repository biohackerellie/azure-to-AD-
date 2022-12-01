#### For groups one at a time######

install-module azuread
import-module azuread
Connect-Azuread


$azgr = 'Azure-Group-ID'
$adgr = 'AD-Group'

$azuremem = [mailaddress[]] (get-AzureADGroupMember -ObjectId $azgr).UserPrincipalName

Add-ADGroupMember -Identity $adgr -Members $azuremem.User
