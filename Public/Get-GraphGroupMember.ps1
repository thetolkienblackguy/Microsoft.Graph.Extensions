Function Get-GraphGroupMember {
    <#
        .DESCRIPTION
        Gets the members of a group, unlike Get-MgGroupMember, this has a recursive option to get the members of nested groups.
        
        .SYNOPSIS
        Gets the members of a group, unlike Get-MgGroupMember, this has a recursive option to get the members of nested groups.
        
        .PARAMETER GroupId
        The Id of the group to get the members of.

        .PARAMETER Recursive
        If specified, will recursively get the members of nested groups. 

        .PARAMETER ExcludeGroups
        If specified, will exclude groups from the results.

        .EXAMPLE
        Get-GraphGroupMember -GroupId "00000000-0000-0000-0000-000000000000"

        .EXAMPLE
        Get-MgGroup -Filter "displayName eq 'My Group'" | Get-GraphGroupMember

        .EXAMPLE
        Get-MgGroup -Filter "displayName eq 'My Group'" | Get-GraphGroupMember -Recursive

        .EXAMPLE
        Get-MgGroup -Filter "displayName eq 'My Group'" | Get-GraphGroupMember -ExcludeGroups

        .INPUTS
        System.String
        System.Management.Automation.SwitchParameter

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
        [guid]$GroupId,
        [Parameter(Mandatory=$false)]
        [switch]$Recursive,
        [Parameter(Mandatory=$false)]
        [switch]$ExcludeGroups
    
    )
    Begin {
        # Create an empty array to hold the output
        $output_obj = [System.Collections.Generic.List[psobject]]::new()

        # Set the endpoint and oData type based on the parameters
        $end_point = If ($recursive) {
            "transitiveMembers"
        
        } Else {
            "members"
        }
        $odata_type = If ($excludeGroups) {
            "/microsoft.graph.user"
        
        } 
    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/groups/$($groupId)/$($end_point)$($odata_type)" 
        $invoke_mg_params["OutputType"] = "PSObject"

        # Loop through the pages of results
        Do {
            $r = Invoke-MgGraphRequest @invoke_mg_params
            [void]$output_obj.Add([pscustomobject]$r.Value)
            $next_link = $r."@odata.nextLink"
            $invoke_mg_params["Uri"] = $next_link
        
        # Loop until there are no more pages
        } While ($next_link)

    } End {
        # Return the output
        $output_obj 

    }
}