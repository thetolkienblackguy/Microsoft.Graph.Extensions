Function New-GraphOutboundCrossTenantSyncJob {
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
        New-GraphOutboundCrossTenantSyncJob -TenantId "00000000-0000-0000-0000-000000000000" -ServicePrincipalId "00000000-0000-0000-0000-000000000000"

        .INPUTS
        System.String

        .OUTPUTS
        System.Object

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/20/2023
        Version: 0.0.1
        Name: New-GraphOutboundCrossTenantSyncJob

        Version History:
        0.0.1 - Alpha Release - 11/20/2023 - Gabe Delaney 

    #>
    [CmdletBinding()]
    [OutputType([system.object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId,
        [Parameter(Mandatory=$true)]
        [string]$ServicePrincipalId

    )
    Begin {
        # Set the error action preference
        $ErrorActionPreference = "Stop"

        # New-MgServicePrincipalSynchronizationJob parameters
        $new_sync_params = @{}
        $new_sync_params["ServicePrincipalId"] = $servicePrincipalId
        $new_sync_params["TemplateId"] = "Azure2Azure"
        $new_sync_params["ErrorAction"] = "Stop" # Not sure why this is needed since the error action preference is set to stop but it wasn't terminating the script without it

        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params["Method"] = "PUT"
        $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$servicePrincipalId/synchronization/secrets"
        $invoke_graph_params["Body"] = @{}
        # Request body
        $invoke_graph_params["Body"]["value"] = [system.collections.arraylist] @()
        [void]$invoke_graph_params["Body"]["value"].Add(@{
            "key" = "CompanyId"
            "value" = $tenantId
        
        })
        [void]$invoke_graph_params["Body"]["value"].Add(@{
            "key" = "AuthenticationType"
            "value" = "SyncPolicy"
        
        })
        [void]$invoke_graph_params["Body"]["value"].Add(@{
            "key" = "SyncAll"
            "value" = "false"
        
        })
    } Process {
        Try {
            # Create the sync job
            $r = New-MgServicePrincipalSynchronizationJob @new_sync_params | Out-Null

        } Catch {
            # If the sync job already exists, continue
            if ($_.Exception.Message -like "*already exists*") {
                Write-Warning -Message "Sync job already exists for service principal $servicePrincipalId"
            
            } Else {
                Write-Error $_.Exception.Message -ErrorAction Stop

            }
        }
        Try {
            # Invoke-MgGraphRequest to save credentials
            Invoke-MgGraphRequest @invoke_graph_params | Out-Null

        } Catch {
            Write-Error $_.Exception.Message -ErrorAction Stop

        }
    } End {
        $r

    }
}