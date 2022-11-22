### Script to add students in IC activite rosters to Security Groups in AD



install-module azuread
import-module azuread
Connect-Azuread


#Convert the Azure classes here. Add additional values as needed

$map = @{
    '9e81251c-016d-401a-8b3b-a7d14253688e' = 'SG-HS-D-Tier-Football' #football
    'acb5986d-b012-477e-925d-28ebe811e268' = 'SG-HS-D-Tier-Volleyball' #Volleyball
    '65c0de83-ddac-47b0-831d-218660081cb4' = 'SG-HS-D-Tier-BSoccer' #Boys Soccer
    'a899d243-b4b6-4ee1-a6b6-15694c7d6615' = 'SG-HS-D-Tier-GSoccer' #Girls Soccer
    '776231f9-33b5-443c-9179-37570f760d05' = 'SG-HS-D-Tier-BGolf' #Boys Golf
    'a94cac98-d4d2-4503-a60b-e58aa6d2801c' = 'SG-HS-D-Tier-GGolf' #Girls Golf
    'd91fb616-f0ee-490e-af9e-ea6386222b7c' = 'SG-HS-D-Tier-CrossCountry' #Cross Country
    'ee1dc021-6b06-4f6d-b51d-3394719dd53e' = 'SG-HS-D-Tier-FallCheer' #Fall Cheerleading
    '410b0ee0-21d3-413f-b7a7-60f740cc534b' = 'SG-HS-D-Tier-SDD' #Speech Drama Debate
}

foreach($pair in $map.GetEnumerator()) {
    $azMembers = [mailaddress[]] (get-AzureADGroupMember -ObjectID $pair.Key).UserPrincipalName
    foreach($adGroup in $pair.Value) {
        Add-AdGroupMember -Identity $adGroup -Members $azMembers.User 
        $allusers = Get-AdGroupMember -Identity $adGroup
                    $remove = Get-AdGroupMember -Identity $adGroup | Where-Object SamAccountName -NotIn $azMembers.User 
                    Remove-ADGroupMember -Identity $adGroup -Members $remove -Confirm:$false ###removes students no longer in the group
        } 
}
