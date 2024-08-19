    Function Add-GraphApplicationRole {
        <#
            .DESCRIPTION
            Adds an application role to an application

            .SYNOPSIS
            Adds an application role to an application

            .PARAMETER ApplicationId
            The application id of the application to add the role to

            .PARAMETER AppRoles
            The app roles to add to the application

            .PARAMETER IncludeDefaultAppRoles
            Include the default app roles in the app roles to add. This is important when you're copying
            app roles from one application to another

            .PARAMETER DisplayName
            The display name of the app role to create

            .PARAMETER Description
            The description of the app role to create

            .PARAMETER AllowedMemberTypes
            The allowed member types of the app role to create

            .PARAMETER IsEnabled
            The is enabled value of the app role to create

            .PARAMETER Value
            The value of the app role to create

            .PARAMETER PassThru
            Return the status code of the request

            .EXAMPLE
            Add-GraphApplicationRole -ApplicationId "00000000-0000-0000-0000-000000000000" -AppRoles @(@{displayName="Test";description="Test";allowedMemberTypes=@("User");isEnabled=$true;value="Test"})
        
            .EXAMPLE
            Get-MgApplication -ApplicationId "00000000-0000-0000-0000-000000000000" | Add-GraphApplicationRole -AppRoles @(@{displayName="Test";description="Test";allowedMemberTypes=@("User");isEnabled=$true;value="Test"})

            .EXAMPLE
            Add-GraphApplicationRole -ApplicationId "00000000-0000-0000-0000-000000000000" -DisplayName "Test" -Description "Test" -AllowedMemberTypes @("User") -IsEnabled $true -Value "Test"
            
            .INPUTS
            System.String
            System.Management.Automation.PSSwitchParameter
            System.Hashtable

            .OUTPUTS
            System.Management.Automation.PSCustomObject

            .NOTES
            Author: Gabriel Delaney | gdelaney@phzconsulting.com
            Date: 12/17/2023
            Version: 0.0.1
            Name: Add-GraphApplicationRole

            Version History:
            0.0.1 - Alpha Release - 12/17/2023 - Gabe Delaney

        #>
        [CmdletBinding(
            DefaultParameterSetName="AppRoles",SupportsShouldProcess=$true,ConfirmImpact="Low"
            
        )]
        [OutputType([System.Management.Automation.PSCustomObject])]
        param (
            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
            [Alias("Id","ServicePrincipalId")]
            [string]$ApplicationId,
            [Parameter(Mandatory=$true,ParameterSetName="AppRoles")]
            [hashtable[]]$AppRoles,
            [Parameter(Mandatory=$false,ParameterSetName="AppRoles")]
            [switch]$IncludeDefaultAppRoles,
            [Parameter(Mandatory=$true,ParameterSetName="CreateAppRole")]
            [string]$DisplayName,
            [Parameter(Mandatory=$true,ParameterSetName="CreateAppRole")]
            [string]$Description,
            [Parameter(Mandatory=$false,ParameterSetName="CreateAppRole")]
            [ValidateSet(
                "User","Application"

            )]
            [string[]]$AllowedMemberTypes = @("User"),
            [Parameter(Mandatory=$false,ParameterSetName="CreateAppRole")]
            [boolean]$IsEnabled = $true,
            [Parameter(Mandatory=$false,ParameterSetName="CreateAppRole")]
            [string]$Value = $displayName,
            [Parameter(Mandatory=$false)]
            [switch]$PassThru
        
        )
        Begin {
            # Create the app role table
            $app_role_table = @{}

            # Create the app role array
            $app_role_array = [System.Collections.Generic.List[PSObject]]::new()

        } Process {
            # Check the parameter set name, if it is input object, then add the input object
            If ($PSCmdlet.ParameterSetName -eq "AppRoles") {
                Foreach ($app_role in $appRoles) {
                    If (!$includeDefaultAppRoles) {
                        # Check if the app role is a default app role
                        If ($app_role.DisplayName -eq "msiam_access") {
                            # Skip the default app role
                            Continue

                        }
                    }
                    # Add the app role to the app role array
                    $app_role_array.Add($app_role)

                }
            } Else {
                #TODO: Encapsulate this
                $app_role_table["displayName"] = $displayName
                $app_role_table["description"] = $description
                $app_role_table["allowedMemberTypes"] = $allowedMemberTypes
                $app_role_table["isEnabled"] = $isEnabled
                $app_role_table["value"] = $value
                $app_role_table["id"] = [guid]::NewGuid().ToString()
                $app_role_table["origin"] = "Application"
                [void]$app_role_array.Add($app_role_table)

            }
            # Allow for the use of WhatIf
            If ($PSCmdlet.ShouldProcess("$($applicationId)","Add-GraphApplicationRole")) {
                # Get the current app roles
                $current_app_roles = Get-GraphApplicationRole -ApplicationId $applicationId

                # Add the new app role to the current app roles
                Foreach ($app_role in $current_app_roles) {
                    [void]$app_role_array.Add($app_role)
                
                }
                # Create the body
                $body = @{}
                $body["appRoles"] = $app_role_array

                # Convert the body to json
                $json_body = $body | ConvertTo-Json -Depth 4  
                
                # Invoke-MgGraphRequest parameters
                $invoke_mg_params = @{}
                $invoke_mg_params["Method"] = "PATCH"
                $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/applications/$applicationId"
                $invoke_mg_params["Body"] = $json_body
                $invoke_mg_params["OutputType"] = "PSObject"
                # Try to invoke the request
                Try {
                    # Invoke the request
                    Invoke-MgGraphRequest @invoke_mg_params | Out-Null

                } Catch {
                    Write-Error $_.Exception.Message -ErrorAction Stop
                
                }
            }
        } End { 
            If ($passThru) {
                Get-GraphApplicationRole -ApplicationId $applicationId
            
            }
        }
    }