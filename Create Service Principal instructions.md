# Service Principal Setup Instructions
 
## Series of instructions and Commands to set up Service Principal Application for automated Azure script authentication                            

you must have the azuread model installed for powershell
```
    Install-Module AzureAD
    import-Moduel AzureAD
```
#Setup In Portal.Azure.com

---

#Setup In Portal.Azure.com

## Start by adding an app registration in Azure portal

App must be single tenant, add Mircorsoft Graph API Permission with User.readwrite.All and Group.ReadWrite.All

Next we will add a signed certificate, you can either generate a self signed cert, instructions here: https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-self-signed-certificate
or in our case, we will use one signed by our local CA. 


On the server the script will be running as a scheduled task, open certlm, and under personal certificates, export one of the Client Authentication certs as 
 Base-64 encoded x.509, do not export the private key.

 Upload the exported cert to the Certificates & Secrets page of the Azure App you created

Next, in Powershell, connect to Azure AD with your admin account
```
    Connect-AzureAD
```

 You will add app roles to the service principle app,depending on what the app needs to do, roles found here https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference

For this example we will be using Global Administrator

You will also need the objectID of the application you created, which can be found in Overview > Managed Application > ObjectId 

## Assign the ObjectID from the app to a variable
```
    $app = <objectId>
```

## The following will add the desired roles to your app
```
    Add-AzureADDirectoryRoleMember -ObjectID <ID of the Role> -RefObjectId $app
```

If you don't know the ObjectID of the role you want, it can still be added like this 
```
    Add-AzureADDirectoryRoleMember -ObjectId (Get-AzureADDirectoryRole | where-object {$_.DisplayName -eq "Global Administrator"}).Objectid -RefObjectId $app
```

Your app can now be used to authenticate Azure Ad Scripts. To run a script as this service principle, add  this line to the start of your script
```
    Connect-AzureAD -TenantId <tenantId> -ApplicationId  <applicationId> -CertificateThumbprint <thumb>
```
TenantId and ApplicationId are both found on the Overview Page of your application, and you can copy the CertThumb from the Certificates & Secrets page

-----------











