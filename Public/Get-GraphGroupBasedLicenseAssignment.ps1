Function Get-GraphGroupBasedLicenseAssignment {
    <#
        .DESCRIPTION
        This function returns licenses assigned to groups.

        .SYNOPSIS
        This function returns licenses assigned to groups.

        .PARAMETER SkuId        
        The sku id of the license to return the groups for. This can be a single sku id or an array of sku ids. 

        .PARAMETER All
        If this switch is specified, all licenses will be returned.

        .EXAMPLE
        Get-GraphGroupBasedLicenseAssignment -SkuId "6fd2c87f-b296-42f0-b197-1e91e994b900"

        .EXAMPLE
        Get-MgSubscribedSku | Get-GraphGroupBasedLicenseAssignment

        .EXAMPLE
        Get-GraphGroupBasedLicenseAssignment -All

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
    param (      
        [Parameter(
            Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,
            ParameterSetName="SkuId"

        )]
        [String[]]$SkuId,
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]$All

    )
    Begin {
        # If the global variable $Global:subscribed_skus is not set, get it
        If (!$Global:subscribed_skus) {          
            Try {
                # cache the subscribed skus
                $Global:subscribed_skus = Get-MgSubscribedSku

            } Catch {
                Write-Error $_ -ErrorAction Stop

            }
            # Create a lookup table for the skus and cache it
            $Global:sku_table = [System.Collections.IDictionary] @{}

            Foreach ($sku in $Global:subscribed_skus) {
                $Global:sku_table[$sku.SkuId] = $sku
            
            }
        } 
        # If the parameter All is specified, get all the skus, leverage the cached $Global:subscribed_skus
        If ($PSBoundParameters.ContainsKey("All")) {
            $skuId = $Global:subscribed_skus.SkuId
            
        }       
    } Process {            
        Foreach ($sku in $skuId) {
            Try {
                # Get all the groups with the specified sku
                $groups = Get-MgGroup -Filter "assignedLicenses/any(s:s/skuId eq $sku)"

            } Catch {
                Write-Error $_ -ErrorAction Continue

            }
            # Get the info for each group
            Foreach ($g in $groups) {
                [GraphLicenseGroupObject]::Create($g, $sku, $Global:sku_table)
            
            }
        }
    } End {

    }
}