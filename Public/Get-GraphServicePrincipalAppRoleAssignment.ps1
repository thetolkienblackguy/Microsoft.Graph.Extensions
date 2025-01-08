Function Get-GraphServicePrincipalAppRoleAssignment {
    <#
        .DESCRIPTION
        This function will return all of the app role assignments for a service principal.

        .SYNOPSIS
        This function will return all of the app role assignments for a service principal.

        .PARAMETER ServicePrincipalId
        The ID of the service principal to get the app role assignments for.

        .PARAMETER AppId
        The App ID of the service principal to get the app role assignments for.

        .PARAMETER Recursive
        If specified, it will return users that are members of groups that are members of the service principal.
        It will not return users are nested within those groups by design.

        .EXAMPLE
        Get-GraphServicePrincipalAppRoleAssignment -ServicePrincipalId 00000000-0000-0000-0000-000000000000

        .EXAMPLE
        Get-GraphServicePrincipalAppRoleAssignment -AppId 00000000-0000-0000-0000-000000000000

        .INPUTS
        System.Guid

        .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    #>
    [CmdletBinding(DefaultParameterSetName="ServicePrincipalId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(
            Mandatory=$true,ParameterSetName="ServicePrincipalId",ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            
        )]
        [Alias('Id')]
        [guid]$ServicePrincipalId,
        [Parameter(Mandatory=$true,ParameterSetName="AppId",ValueFromPipelineByPropertyName=$true)]
        [guid]$AppId,
        [Parameter(Mandatory=$false)]
        [switch]$Recursive
    
    )
    Begin {
        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Invoke-MgGraphRequest:Method"] = "GET"
        $PSDefaultParameterValues["Invoke-MgGraphRequest:OutputType"] = "PSObject"

        # Get-GraphGroupMember parameters
        $get_member_params = @{}
        $get_member_params["ExcludeGroups"] = $true
        
        # Create a new list to store output objects
        $output_obj = [System.Collections.Generic.List[psobject]]::new()

        # Create a new ordered hash table to store object properties
        $obj = [ordered] @{}
        
    } Process {
        # Create identifier property for the request
        If ($PSCmdlet.ParameterSetName -eq "ServicePrincipalId") {
            $id = "/$($servicePrincipalId)"
            
        } Else {
            $id = "(appId='$($appId)')"
        
        }
        # Create the URIs for the request
        $role_assigned_uri = "https://graph.microsoft.com/v1.0/servicePrincipals$($id)/appRoleAssignedTo"
        $app_role_uri = "https://graph.microsoft.com/v1.0/servicePrincipals$($id)?`$select=appRoles"
        Try {
            # Loop through app role assignments
            $principals = Do {
                $r = Invoke-MgGraphRequest -Uri $role_assigned_uri
                $r.value
                $next_link = $r."@odata.nextLink"
                $role_assigned_uri = $next_link
            
            # Loop until there is no next link
            } While ($next_link)

            # Get the app roles
            $app_roles = Do {
                $r = Invoke-MgGraphRequest -Uri $app_role_uri
                $r.AppRoles
                $next_link = $r."@odata.nextLink"
                $app_role_uri = $next_link

            # Loop until there is no next link
            } While ($next_link)
            
            # Create app role lookup table
            $app_role_table = [GraphAppRoleTable]::new($app_roles).GetTable()
            Foreach ($principal in $principals) {
                # If the principal is a group, get the members
                If ($principal.PrincipalType -eq "Group" -and $recursive) {
                    $members = Get-GraphGroupMember -GroupId $principal.principalId @get_member_params
                    Foreach ($member in $members) {
                        $obj = [GraphRoleAssignmentPrincipalObject]::Create($principal, $app_role_table, $member)
                        [void]$output_obj.Add($obj)
                    }
                } Else {
                    $obj = [GraphRoleAssignmentPrincipalObject]::Create($principal, $app_role_table, $null)
                    [void]$output_obj.Add($obj)
               
                }
            }
        } Catch {
            Write-Error -Message $_.Exception.Message -ErrorAction Stop

        }
    } End {
        # Return the output object
        $output_obj

    }
}