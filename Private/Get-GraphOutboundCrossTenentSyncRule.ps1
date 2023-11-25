Function Get-GraphOutboundCrossTenentSyncRule {
    <#
        .DESCRIPTION
        This function will return the outbound sync rule for a given service principal.

        .SYNOPSIS
        This function will return the outbound sync rule for a given service principal.

        .PARAMETER ServicePrincipalId
        The service principal id of the service principal you want to get the outbound sync rule for.

        .EXAMPLE
        Get-GraphOutboundCrossTenentSyncRule -ServicePrincipalId "00000000-0000-0000-0000-000000000000"

        .INPUTS
        System.String

        .OUTPUTS
        System.Object

        .NOTES
        Author: Gabriel Delaney
        Date: 11/24/2023
        Version: 0.0.1
        Name: Get-GraphOutboundCrossTenentSyncRule

        Version History:
        0.0.1 - Alpha Release - 11/24/2023 - Gabe Delaney
    
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServicePrincipalId
    
    )
    Begin {
        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params["Method"] = "GET"
        $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$servicePrincipalId/synchronization/jobs?`$filter=tentantId eq 'Azure2Azure'"
        $invoke_graph_params["OutputType"] = "PSObject"
        $invoke_graph_params["ErrorAction"] = "Stop"

    } Process {
        Try {
            $r = Invoke-MgGraphRequest @invoke_graph_params

        } Catch {
            Write-Error $_

        }
    } End {
        $r.value

    }
}