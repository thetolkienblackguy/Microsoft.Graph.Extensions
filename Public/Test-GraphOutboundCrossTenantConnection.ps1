Function Test-GraphOutboundCrossTenantConnection {
    <#
        .DESCRIPTION
        Tests Microsoft Entra Id cross-tenant synchronization credentials

        .SYNOPSIS
        Tests Microsoft Entra Id cross-tenant synchronization credentials

        .PARAMETER TenantId
        The tenant ID of the target tenant

        .PARAMETER ServicePrincipalId
        The service principal ID of the target tenant

        .EXAMPLE
        Test-GraphOutboundCrossTenantConnection -TenantId "00000000-0000-0000-0000-000000000000" -ServicePrincipalId "00000000-0000-0000-0000-000000000000"

        .INPUTS
        System.String

        .OUTPUTS
        System.Boolean

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/20/2023
        Version: 0.0.1
        Name: Test-GraphOutboundCrossTenantConnection

        Version History:
        0.0.1 - Alpha Release - 11/20/2023 - Gabe Delaney 

    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId,
        [Parameter(Mandatory=$true)]
        [string]$ServicePrincipalId

    )
    Begin {
        # Create the output object
        $output_obj = [ordered] @{}
        $output_obj["TenantId"] = $tenantId
        $output_obj["ServicePrincipalId"] = $servicePrincipalId

        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params["Method"] = "POST"
        $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$servicePrincipalId/synchronization/jobs/validateCredentials"
        $invoke_graph_params["Body"] = @{}
        # Request body
        $invoke_graph_params["Body"]["useSavedCredentials"] = $false
        $invoke_graph_params["Body"]["templateId"] = "Azure2Azure" 
        $invoke_graph_params["Body"]["credentials"] = [system.collections.arraylist] @()
        [void]$invoke_graph_params["Body"]["credentials"].Add(@{
            "key" = "CompanyId"
            "value" = $tenantId
        
        })
        [void]$invoke_graph_params["Body"]["credentials"].Add(@{
            "key" = "AuthenticationType"
            "value" = "SyncPolicy"
        
        })
        $invoke_graph_params["ErrorAction"] = "Stop"
    } Process {
        Try {
            # Invoke-MgGraphRequest to test credentials
            Invoke-MgGraphRequest @invoke_graph_params

            # If no exception is thrown, the credentials are valid
            $credentials_valid = $true
        } Catch {
            # If an exception is thrown, the credentials are invalid
            $credentials_valid = $false

        }
    } End {
        # Return the credentials status
        $output_obj["CredentialsValid"] = $credentials_valid
        [pscustomobject]$output_obj

    }
}