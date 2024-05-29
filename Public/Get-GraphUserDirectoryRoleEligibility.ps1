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
        Author: Gabriel Delaney
        Date: 05/29/2024
        Version: 0.0.1
        Name: Get-GraphUserDirectoryRoleEligibility

        Version History:
        0.0.1 - Original Release - Gabriel Delaney - 05/29/2024

    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$UserId
    
    )
    Begin {
        # Setting the error action preference
        $ErrorActionPreference = "Stop"
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:MemberType"] = "NoteProperty"
        $PSDefaultParameterValues["Add-Member:Force"] = $true

        # Setting the function name
        $function = $MyInvocation.MyCommand.Name

        # Properties to select
        $role_def_properties = @(
            "DisplayName","Id","Description"

        )
        
    } Process {
        # Get-MgUser 
        $mg_user = Get-MgUser -filter "Id eq '$userId'"
        If (!$mg_user) {
            # Setting the error details
            $error_details_params = @{}
            $error_details_params["Message"] = "Resource '$userId' does not exist or one of its queried reference-property objects are not present"
            $error_details_params["Identity"] = $userId
            $error_details_params["Function"] = $function
            $error_details_params["Category"] = "ObjectNotFound"
            $error_details_params["CategoryTargetType"] = "Microsoft.Graph.User"
            $write_error_params = Set-ErrorDetails @error_details_params

            # Setting the error message
            Write-Error @write_error_params
            Break

        } Else {
            $id = $mg_user.Id
        
        }
 
        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleEligibilityScheduleInstances?`$count=true&`$filter=principalId eq '$id'&`$expand=roleDefinition"
        $invoke_graph_params["Method"] = "GET"
        $invoke_graph_params["Headers"] = @{}
        $invoke_graph_params["Headers"]["ConsistencyLevel"] = "eventual"

        # Add-Member parameters
        $add_member_params = @{}
        $add_member_params["Name"] = "AssignmentState"
        $add_member_params["Value"] = "Eligible"

        # Creating an array list to store the role assignments
        $role_assignments = [System.Collections.ArrayList]::new()

        # Getting the role assignments
        $roles = Do {
            $r = (Invoke-MgGraphRequest @invoke_graph_params)
            $r.Value
            $invoke_graph_params["Uri"] = $r."@odata.nextLink"
        
        # Looping through the results until there are no more results
        } Until (!$r."@odata.nextLink")

        Foreach ($role in $roles) {
            # Getting the role
            $role_def = $role.roleDefinition | Select-Object $role_def_properties
            $role_def | Add-Member -Name principalId -Value $role.id
            
            # Adding the role assignment to the array list
            [void]$role_assignments.Add($role_def)

        }
        # Adding the assignment state to the role assignments
        $role_assignments | Add-Member @add_member_params

        # Returning the role assignments
        $role_assignments 
        
    } End {


    }
}