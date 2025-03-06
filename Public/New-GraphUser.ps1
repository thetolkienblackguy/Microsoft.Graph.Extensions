function New-GraphUser {
    <#
        .SYNOPSIS
        Create a new user in Microsoft Graph

        .DESCRIPTION
        This function creates a new user in Microsoft Graph

        .PARAMETER UserPrincipalName
        Specifies the user principal name of the user.

        .PARAMETER AccountEnabled
        Specifies whether the account is enabled.

        .PARAMETER DisplayName
        Specifies the display name of the user.

        .PARAMETER MailNickname
        Specifies the mail nickname of the user.

        .PARAMETER PasswordProfile  
        Specifies the password profile of the user.

        .PARAMETER GivenName
        Specifies the given name of the user.

        .PARAMETER Surname
        Specifies the surname of the user.

        .PARAMETER JobTitle
        Specifies the job title of the user.

        .PARAMETER Department
        Specifies the department of the user.

        .PARAMETER OfficeLocation
        Specifies the office location of the user.

        .PARAMETER MobilePhone
        Specifies the mobile phone of the user.

        .PARAMETER City
        Specifies the city of the user.

        .PARAMETER State
        Specifies the state of the user.

        .PARAMETER Country
        Specifies the country of the user.

        .PARAMETER StreetAddress
        Specifies the street address of the user.

        .PARAMETER PostalCode
        Specifies the postal code of the user.

        .PARAMETER PreferredLanguage
        Specifies the preferred language of the user.

        .PARAMETER UsageLocation
        Specifies the usage location of the user.

        .PARAMETER EmployeeId
        Specifies the employee ID of the user.

        .PARAMETER PassThru
        Specifies whether to pass the created user object to the pipeline.

        .EXAMPLE
        New-GraphUser -UserPrincipalName "john.doe@contoso.com" -AccountEnabled $true -DisplayName "John Doe" -MailNickname "john.doe" -PasswordProfile $(New-GraphPasswordProfile -ForceChangePasswordNextSignIn:$false)

        .EXAMPLE
        New-GraphUser -UserPrincipalName "john.doe@contoso.com" -AccountEnabled $true -DisplayName "John Doe" -MailNickname "john.doe"  -Department "Sales" -JobTitle "Sales Manager" -OfficeLocation "123 Main St" -MobilePhone "555-1234" -City "Anytown" -State "CA" -Country "USA" -StreetAddress "123 Main St" -PostalCode "12345" -PreferredLanguage "en-US" -UsageLocation "US" -EmployeeId "1234567890"

        .INPUTS
        System.Boolean
        System.String
        System.Object

        .OUTPUTS
        System.Object   
        
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    [OutputType([object])]
    Param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]$UserPrincipalName,
        [Parameter(Mandatory=$true,Position=1)]
        [bool]$AccountEnabled,
        [Parameter(Mandatory=$true,Position=2)]
        [string]$DisplayName,
        [Parameter(Mandatory=$true,Position=3)]
        [string]$MailNickname,
        [Parameter(Mandatory=$false)]
        [hashtable]$PasswordProfile = $(New-GraphPasswordProfile -ForceChangePasswordNextSignIn:$false),  
        [Parameter(Mandatory=$false)]
        [string]$GivenName,
        [Parameter(Mandatory=$false)]
        [string]$Surname,
        [Parameter(Mandatory=$false)]
        [string]$JobTitle,
        [Parameter(Mandatory=$false)]
        [string]$Department,
        [Parameter(Mandatory=$false)]
        [string]$OfficeLocation,
        [Parameter(Mandatory=$false)]
        [string]$MobilePhone,
        [Parameter(Mandatory=$false)]
        [string]$City,
        [Parameter(Mandatory=$false)]
        [string]$State,        
        [Parameter(Mandatory=$false)]
        [string]$Country,
        [Parameter(Mandatory=$false)]
        [string]$StreetAddress,
        [Parameter(Mandatory=$false)]
        [string]$PostalCode,
        [Parameter(Mandatory=$false)]
        [string]$PreferredLanguage,
        [Parameter(Mandatory=$false)]
        [string]$UsageLocation,
        [Parameter(Mandatory=$false)]
        [string]$EmployeeId,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    )
    Begin {
        # Create a request body
        $request_body = @{}
        $request_body["accountEnabled"] = $accountEnabled
        $request_body["displayName"] = $displayName
        $request_body["mailNickname"] = $mailNickname
        $request_body["userPrincipalName"] = $userPrincipalName
        $request_body["passwordProfile"] = $passwordProfile

        # Exclude the request body keys and common parameters from the parameter list, this allows us to dynamically add optional parameters to the request body
        $key_exclusions = @($request_body.Keys + [System.Management.Automation.PSCmdlet]::CommonParameters + @("PassThru", "Confirm", "WhatIf")) 

        # Add the optional parameters to the request body
        ForEach ($key in $PSBoundParameters.Keys) {
            # If the parameter is not in the key exclusions, add it to the request body
            If ($key -notin $key_exclusions) {
                $request_body[$key] = $PSBoundParameters[$key]
            
            }
        }
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "POST"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/users"
        $invoke_mg_params["Body"] = $request_body | ConvertTo-Json -Depth 10
        $invoke_mg_params["ContentType"] = "application/json"

    } Process {
        Try {
            If ($PSCmdlet.ShouldProcess($userPrincipalName,"Create a new user in Microsoft Graph")) {
                # Invoke the request
                $r = Invoke-MgGraphRequest @invoke_mg_params

            }
        } Catch {
            # If the error is a duplicate user error, return the user object
            Write-Error "Error creating user: $_" -ErrorAction Stop
        
        }
    } End {
        # If the pass thru parameter is true, return the user object
        If ($passThru) {
            $r
        
        }
    }
}