
install-module azuread
import-module azuread
Connect-Azuread


#Convert the Azure groups here. Add additional values as needed

$map = @{
    '<Azure-Object-ID-01' = 'Active_directory-Security-Group-1' 
    '<Azure-Object-ID-02' = 'Active_directory-Security-Group-2' 
    '<Azure-Object-ID-03' = 'Active_directory-Security-Group-3'  
    '<Azure-Object-ID-04' = 'Active_directory-Security-Group-4'  
}

foreach($pair in $map.GetEnumerator()) {
    $azMembers = [mailaddress[]] (get-AzureADGroupMember -ObjectID $pair.Key).UserPrincipalName
    foreach($adGroup in $pair.Value) {
        Add-AdGroupMember -Identity $adGroup -Members $azMembers.User 
        $allusers = Get-AdGroupMember -Identity $adGroup
                    ##remove users no longer in Azure Group
                    $remove = Get-AdGroupMember -Identity $adGroup | Where-Object SamAccountName -NotIn $azMembers.User 
                    Remove-ADGroupMember -Identity $adGroup -Members $remove -Confirm:$false 
        } 
}
