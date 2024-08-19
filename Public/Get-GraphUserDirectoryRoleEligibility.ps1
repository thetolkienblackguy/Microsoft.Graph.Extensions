Function Get-GraphUserDirectoryRoleEligibility {
    <#
        .DESCRIPTION
        Gets the directory role eligibility for a user

        .SYNOPSIS
        Gets the directory role eligibility for a user

        .PARAMETER UserId
        Specifies the UserId

        .EXAMPLE
        Get-GraphUserDirectoryRoleEligibility-UserId "jdoe@contoso.com"

        .INPUTS
        System.String

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 05/29/2024
        Version: 0.0.1
        Name: Get-GraphUserDirectoryRoleEligibility

        Version History:
        0.0.1 - Alpha Release - Gabriel Delaney - 05/29/2024

    #>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias("Id","UserPrincipalName","UPN")]
        [string[]]$UserId
    
    )
    Begin {
        # Setting the error action preference
        $ErrorActionPreference = "Stop"

        # Setting the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:MemberType"] = "NoteProperty"
        $PSDefaultParameterValues["Add-Member:Force"] = $true

        # Properties to select
        $role_def_properties = @(
            "DisplayName","Id"

        )

        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        # Add-Member parameters
        $add_member_params = @{}
        $add_member_params["Name"] = "AssignmentState"
        $add_member_params["Value"] = "Eligible"

    } Process {
        # Get-GraphUser
        Try {
            $mg_user = Get-GraphUser -UserId $userId
            $id = $mg_user.Id
            $upn = $mg_user.UserPrincipalName

        } Catch {
            # Write the error and stop the script if an error occurs
            Write-Error $_ -ErrorAction Stop
        
        }
        # Setting the URI
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleEligibilityScheduleInstances?`$count=true&`$filter=principalId eq '$id'&`$expand=roleDefinition"

        # Creating an array list to store the role assignments
        $role_assignments = [System.Collections.ArrayList] @()

        # Getting the role assignments
        Try {
            $roles = Do {
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                $r.Value
                $invoke_mg_params["Uri"] = $r."@odata.nextLink"
            
            # Looping through the results until there are no more results
            } Until (!$r."@odata.nextLink")

        } Catch {
            # Write the error and stop the script if an error occurs
            Write-Error $_ -ErrorAction Stop

        }
        # Looping through the roles
        Foreach ($role in $roles) {
            # Getting the role
            $role_def = $role.roleDefinition | Select-Object $role_def_properties
            $role_def | Add-Member -Name principalId -Value $role.id
            
            # Adding the role assignment to the array list
            [void]$role_assignments.Add($role_def)

        }
        # Adding the assignment state to the role assignments
        $role_assignments | Add-Member @add_member_params

        # Adding the user principal name to the roles
        $role_assignments | Add-Member -Name UserPrincipalName -Value $upn

        # Returning the role assignments
        $role_assignments 
        
    } End {

    }
}