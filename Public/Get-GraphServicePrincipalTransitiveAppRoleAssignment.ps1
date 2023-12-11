Function Get-GraphServicePrincipalTransitiveAppRoleAssignment {
    <#
        .DESCRIPTION
        This function will return all of the app role assignments for a service principal and all of its transitive members.

        .PARAMETER ServicePrincipalId
        The ID of the service principal to get the app role assignments for.

        .PARAMETER AppId
        The App ID of the service principal to get the app role assignments for.

        .EXAMPLE
        Get-GraphServicePrincipalTransitiveAppRoleAssignment -ServicePrincipalId 00000000-0000-0000-0000-000000000000

        .EXAMPLE
        Get-GraphServicePrincipalTransitiveAppRoleAssignment -AppId 00000000-0000-0000-0000-000000000000

        .INPUTS
        System.Guid

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 12/11/2023
        Version: 0.0.1
        Name: Get-GraphServicePrincipalTransitiveAppRoleAssignment

        Version History:
        0.0.1 - Alpha Release - 12/11/2023 - Gabe Delaney
    
    #>
    [CmdletBinding(DefaultParameterSetName="ServicePrincipalId")]
    param (
        [Parameter(
            Mandatory=$true,ParameterSetName="ServicePrincipalId",ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            
        )]
        [Alias('Id')]
        [guid]$ServicePrincipalId,
        [Parameter(Mandatory=$true,ParameterSetName="AppId",ValueFromPipelineByPropertyName=$true)]
        [guid]$AppId
    
    )
    Begin {
        # Create a new list to store principals
        $principals = [System.Collections.Generic.List[psobject]]::new()

        # Create a new list to store output objects
        $output_obj = [System.Collections.Generic.List[psobject]]::new()

        # Create a new ordered hash table to store object properties
        $obj = [ordered] @{}

        # Create the URI for the request
        If ($PSCmdlet.ParameterSetName -eq "ServicePrincipalId") {
            $id = "/$($servicePrincipalId)"
            
        } Else {
            $id = "(appId='$($appId)')"
        
        }
    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals$($id)/appRoleAssignedTo"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["OutputType"] = "PSObject"

        # Loop through the page results
        Do {
            $response = Invoke-MgGraphRequest @invoke_mg_params
            [void]$principals.Add($response.value)
            $next_link = $response."@odata.nextLink"
            $invoke_mg_params["Uri"] = $next_link
        
        # Loop until there is no next link
        } While ($next_link)
        Foreach ($principal in $principals) {
            # If the principal is a group, get the members
            If ($principal.PrincipalType -eq "Group") {
                $members = Get-GraphGroupTransitiveMember -GroupId $principal.principalId
                
                # Loop through the members and add them to the output object
                Foreach ($member in $members) {
                    $obj["DisplayName"] = $member.displayName
                    $obj["Id"] = $member.id
                    [void]$output_obj.Add([pscustomobject]$obj)

                }
            
                # If the principal is not a group, add it to the output object
            } Else {
                $obj["DisplayName"] = $principal.principalDisplayName
                $obj["Id"] = $principal.principalId
                [void]$output_obj.Add([pscustomobject]$obj)

            }
        }
    } End {
        # Return the output object
        $output_obj

    }
}