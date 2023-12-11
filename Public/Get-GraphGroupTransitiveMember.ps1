Function Get-GraphGroupTransitiveMember {
    <#
        .DESCRIPTION
        Gets the members of a group, including transitive members. This function will return all members of a group, including members of nested groups. 
        This function will only return users, not other groups.
        
        .SYNOPSIS
        Gets the members of a group, including transitive members.
        
        .PARAMETER GroupId
        The Id of the group to get the members of.

        .EXAMPLE
        Get-GraphGroupTransitiveMember -GroupId "00000000-0000-0000-0000-000000000000"

        .EXAMPLE
        Get-MgGroup -Filter "displayName eq 'My Group'" | Get-GraphGroupTransitiveMember

        .INPUTS
        System.String

        .OUTPUTS
        System.Collections.Generic.List[psobject]

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 12/11/2023
        Version: 0.0.1
        Name: Get-GraphGroupTransitiveMember

        Version History:
        0.0.1 - Alpha Release - 12/11/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[psobject]])]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
        [Alias("Id")]
        [string]$GroupId
    
    )
    Begin {
        # Create an empty array to hold the output
        $output_obj = [System.Collections.Generic.List[psobject]]::new()

    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/groups/$groupId/transitiveMembers/microsoft.graph.user" # Only get users, not other groups
        $invoke_mg_params["OutputType"] = "PSObject"

        # Loop through the pages of results
        Do {
            $r = Invoke-MgGraphRequest @invoke_mg_params
            [void]$output_obj.Add($r.Value)
            $next_link = $r."@odata.nextLink"
            $invoke_mg_params["Uri"] = $next_link
        
        # Loop until there are no more pages
        } While ($next_link)

    } End {
        # Return the output
        $output_obj 

    }
}