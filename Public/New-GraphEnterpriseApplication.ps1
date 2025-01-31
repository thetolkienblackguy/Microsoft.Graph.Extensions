Function New-GraphEnterpriseApplication {
    <#
        .DESCRIPTION
        Creates a new enterprise application in Entra Id using the Microsoft Graph API.

        .SYNOPSIS
        Creates a new enterprise application in Azure AD using the Microsoft Graph API.

        .PARAMETER DisplayName
        The display name of the new enterprise application.

        .PARAMETER SignInAudience
        The sign-in audience of the new enterprise application. The default value is "AzureADMyOrg".

        .PARAMETER PreferredSingleSignOnMode
        The preferred single sign-on mode of the new enterprise application. The default value is "notSupported".

        .PARAMETER Tags
        The tags of the new enterprise application. The default value is "WindowsAzureActiveDirectoryCustomSingleSignOnApplication" and "WindowsAzureActiveDirectoryIntegratedApp".

        .PARAMETER LoginUrl
        The login URL of the new enterprise application.

        .PARAMETER LogoutUrl
        The logout URL of the new enterprise application.

        .PARAMETER ReplyUrls
        The reply URLs of the new enterprise application.

        .PARAMETER NotificationEmailAddresses
        The notification email addresses of the new enterprise application. The default value is the email address of the current user.

        .PARAMETER Logo
        The logo of the new enterprise application.
        
        .PARAMETER Description
        The description of the new enterprise application. The default value is "Enterprise Application created by New-GraphEnterpriseApplication".

        .PARAMETER AppRoleAssignmentRequired
        The app role assignment required of the new enterprise application. The default value is $true.

        .PARAMETER VisibleToUsers
        The visible to users of the new enterprise application. The default value is $true.

        .PARAMETER PassThru
        Pass the output object through if -PassThru is specified.

        .EXAMPLE
        New-GraphEnterpriseApplication -DisplayName "MyApp" 

        .EXAMPLE
        New-GraphEnterpriseApplication -DisplayName "MyApp" -SignInAudience "AzureADMyOrg" -PreferredSingleSignOnMode "notSupported" -Tags "WindowsAzureActiveDirectoryCustomSingleSignOnApplication", "WindowsAzureActiveDirectoryIntegratedApp" -LoginUrl "https://myapp.com/login" -LogoutUrl "https://myapp.com/logout" -ReplyUrls "https://myapp.com/reply"

        .INPUTS
        String
        Uri
        System.IO.FileInfo
        Boolean
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory=$true)]
        [Alias("AppDisplayName")]
        [string]$DisplayName,
        [Parameter(Mandatory=$false)]
        [validateset(
            "AzureADMyOrg", "AzureADMultipleOrgs",
            "AzureADandPersonalMicrosoftAccount"

        )]
        [string]$SignInAudience = "AzureADMyOrg",
        [Parameter(Mandatory=$false)]
        [AllowNull()]
        [validateset(
            "saml", "password", "notSupported", $null
        
        )]
        [string]$PreferredSingleSignOnMode = "notSupported",
        [Parameter(DontShow=$true)]
        [string[]]$Tags = @(
            "WindowsAzureActiveDirectoryCustomSingleSignOnApplication",
            "WindowsAzureActiveDirectoryIntegratedApp"

        ),
        [Parameter(Mandatory=$false)]
        [uri]$LoginUrl,
        [Parameter(Mandatory=$false)]
        [uri]$LogoutUrl,
        [Parameter(Mandatory=$false)]
        [uri[]]$ReplyUrls,
        [Parameter(Mandatory=$false)]
        [string[]]$NotificationEmailAddresses = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/me").Mail,
        [Parameter(Mandatory=$false)]
        [string]$Description = "Enterprise Application created by New-GraphEnterpriseApplication",
        [Parameter(Mandatory=$false)]
        [ValidateScript({
            If (Test-Path $_) {
                $true

            } Else {
                Throw "The file does not exist"
            
            }
        })]
        [system.io.fileinfo]$Logo,
        [Parameter(Mandatory=$false)]
        [boolean]$AppRoleAssignmentRequired = $true,
        [Parameter(Mandatory=$false)]
        [boolean]$VisibleToUsers = $true,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru

    )
    Begin {
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Invoke-MgGraphRequest:Method"] = "POST"
        $PSDefaultParameterValues["Invoke-MgGraphRequest:OutputType"] = "PSObject"
        $PSDefaultParameterValues["ConvertTo-Json:Depth"] = 10

        # Add the "HideApp" tag if the application is not visible to users
        If (!$visibleToUsers) {
            $tags += "HideApp"

        }
        # Create the new application request body
        $new_app_body = @{}
        $new_app_body["DisplayName"] = $displayName 
        $new_app_body["Description"] = $description
        $new_app_body["SignInAudience"] = $signInAudience
        $new_app_body["Tags"] = $tags

        # Invoke-MgGraphRequest parameters
        $new_app_params = @{}
        $new_app_params["Body"] = $new_app_body | ConvertTo-Json
        $new_app_params["Uri"] = "https://graph.microsoft.com/v1.0/applications"

        # Create the new service principal request body
        $new_sp_body = @{}
        $new_sp_body["AppRoleAssignmentRequired"] = $appRoleAssignmentRequired
        $new_sp_body["PreferredSingleSignOnMode"] = $preferredSingleSignOnMode
        $new_sp_body["LoginUrl"] = $loginUrl
        $new_sp_body["LogoutUrl"] = $logoutUrl
        If ($replyUrls) {
            $new_sp_body["ReplyUrls"] = $replyUrls

        }
        $new_sp_body["NotificationEmailAddresses"] = $notificationEmailAddresses

        # Invoke-MgGraphRequest parameters
        $new_sp_params = @{}
        $new_sp_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals"

    } Process {
        Try {
            # Create the new application
            $r = Invoke-MgGraphRequest @new_app_params
            $app_id = $r.AppId
            $id = $r.Id

            # Wait for the application to be created
            Start-Sleep -Seconds 5

            # Get the new application Id and add it to the service principal body
            $new_sp_body["AppId"] = $app_id

            # Finish the Invoke-MgGraphRequest parameters
            $new_sp_params["Body"] = $new_sp_body | ConvertTo-Json

            # Create the new service principal
            $r = Invoke-MgGraphRequest @new_sp_params

            # Set the logo if specified
            If ($logo) {
                $set_logo_params = @{}
                $set_logo_params["Uri"] = "https://graph.microsoft.com/v1.0/applications/$id/logo"
                $set_logo_params["Method"] = "PUT"
                $set_logo_params["Body"] = [System.IO.File]::ReadAllBytes((Get-Item $logo).FullName)
                $set_logo_params["ContentType"] = "image/*"

                # Set the logo
                Invoke-MgGraphRequest @set_logo_params | Out-Null
            
            }
        } Catch {
            # Write the error message and stop the script
            Write-Error -Message $_.Exception.Message -ErrorAction Stop
            
        }
    } End {
        # Pass the output object through if -PassThru is specified
        If ($passThru) {
            $r
        
        }
    }
}