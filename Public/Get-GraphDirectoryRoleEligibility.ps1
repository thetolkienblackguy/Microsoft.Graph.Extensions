Function Get-GraphDirectoryRoleEligibility {
    <#
        .DESCRIPTION
        Gets the directory role eligibility for a principal

        .SYNOPSIS
        Gets the directory role eligibility for a principal

        .PARAMETER PrincipalId
        Specifies the PrincipalId

        .EXAMPLE
        Get-GraphDirectoryRoleEligibility -PrincipalId "12345678-1234-1234-1234-123456789012"

        .INPUTS
        System.String

        .OUTPUTS
        System.Object[]

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$PrincipalId
    
    )
    Begin {
        # Setting the error action preference
        $ErrorActionPreference = "Stop"
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:MemberType"] = "NoteProperty"
        $PSDefaultParameterValues["Add-Member:Force"] = $true

        # Properties to select
        $role_def_properties = @(
            "DisplayName","Id","Description"

        )
    } Process {
        # Invoke-MgGraphRequest parameter
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleEligibilityScheduleInstances?`$count=true&`$filter=principalId eq '$id'&`$expand=roleDefinition"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        # Add-Member parameters
        $add_member_params = @{}
        $add_member_params["Name"] = "AssignmentState"
        $add_member_params["Value"] = "Eligible"
        
        # Getting the role assignments
        $roles = Do {
            $r = (Invoke-MgGraphRequest @invoke_mg_params)
            $r.Value
            $invoke_mg_params["Uri"] = $r."@odata.nextLink"
        
        # Looping through the results until there are no more results
        } Until (!$r."@odata.nextLink")

        # Adding the assignment state to the role assignments
        $roles | Add-Member @add_member_params

        # Looping through the roles
        Foreach ($role in $roles) {
            # Getting the role
            $role_def = $role.roleDefinition | Select-Object $role_def_properties
            
            # Adding the principalId to the role definition
            $role_def | Add-Member -Name principalId -Value $principalId
            
            # Returning the role definition
            $role_def

        }
    } End {

    }
}