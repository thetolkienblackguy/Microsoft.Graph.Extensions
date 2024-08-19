Function Get-GraphGroupBasedLicenseAssignment {
    <#
        .DESCRIPTION
        This function returns licenses assigned to groups.

        .SYNOPSIS
        This function returns licenses assigned to groups.

        .PARAMETER SkuId        
        The sku id of the license to return the groups for. This can be a single sku id or an array of sku ids. 


        .EXAMPLE
        Get-GraphGroupBasedLicenseAssignment -SkuId "6fd2c87f-b296-42f0-b197-1e91e994b900"

        .EXAMPLE
        Get-MgSubscribedSku | Get-GraphGroupBasedLicenseAssignment | Format-List

        .INPUTS
        System.String

        .OUTPUTS
        System.Object

        .LINK
        https://docs.microsoft.com/en-us/graph/api/resources/subscribedsku?view=graph-rest-1.0

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/14/2023
        Version: 0.0.1
        Name: Get-GraphGroupBasedLicenseAssignment

        Version History:
        0.0.1 - Alpha Release - 11/14/2023 - Gabe Delaney

    #>
    [CmdletBinding(DefaultParameterSetName="SkuId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (      
        [Parameter(
            Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,
            ParameterSetName="SkuId"

        )]
        [String]$SkuId

    )
    Begin {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        # Setting the group properties to return
        $group_properties = @(
            "DisplayName","Id"
        
        )

        # Get the subscribed skus and cache them
        If (!$Script:subscribed_skus) {
            $Script:subscribed_skus = [System.Collections.Generic.List[PSCustomObject]]::new()
            $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/subscribedSkus"
            Do {
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                $Script:subscribed_skus.Add($r.Value)
                $invoke_mg_params["Uri"] = $r."@odata.nextLink"

            } Until (!$r."@odata.nextLink")
        }

        # Create a lookup table for the skus and cache it
        If (!$Script:sku_lookup_table) {
            $Script:sku_lookup_table = [System.Collections.IDictionary] @{}
            Foreach ($sku in $subscribed_skus) {
                $sku_lookup_table[$sku.SkuId] = $sku

            }
        }
    } Process {
        # Setting the users array
        $groups = [System.Collections.Generic.List[PSCustomObject]]::new()
        
        # Add uri to invoke_mg_params hashtable 
        $filter = "assignedLicenses/any(s:s/skuId eq $skuId)"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/groups?`$filter=$filter&`$select=$($group_properties -join ",")"
        Try {
            # Get all the groups with the specified sku
            Do {
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                $groups.Add($r.Value)
                $invoke_mg_params["Uri"] = $r."@odata.nextLink"
            
            # Looping through the results until there are no more results
            } Until (!$r."@odata.nextLink")

        } Catch {
            # Write the error to the console
            Write-Error -Message $_

        }
        # Get the info for each group
        Foreach ($g in $groups) {
            [GraphLicenseGroupObject]::Create($g, $skuId, $sku_lookup_table)
                  
        }    
    } End {

    }
}