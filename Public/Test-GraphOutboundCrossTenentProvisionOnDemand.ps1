Function Test-GraphOutboundCrossTenantProvisonOnDemand {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServicePrincipalId,
        [Parameter(Mandatory=$true)]
        [string]$ObjectId,
        [Parameter(Mandatory=$true)]
        [validateset(
            "User","Group"
            
        )]
        [string]$ObjectTypeName

    )
    Begin {
        # Set the default parameters
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["*:ServicePrincipalId"] = $servicePrincipalId
        
        # Set-GraphProvisionOnDemandBody parameters
        $set_body_params = @{}
        $set_body_params["ObjectId"] = $objectId
        $set_body_params["ObjectTypeName"] = $objectTypeName

    } Process {
        Try {
            # Get the Azure2Azure outbound sync rule id
            $rule_id = (Get-GraphOutboundCrossTenentSyncRule).id

            # Set the provisioning body
            $provisioning_body = Set-GraphProvisionOnDemandbody @set_body_params -RuleId $rule_id
            
            # Invoke-MgGraphRequest parameters for the provisioning request
            $invoke_graph_params = @{}
            $invoke_graph_params["Method"] = "POST"
            $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$servicePrincipalId/synchronization/jobs/$rule_id/provisionOnDemand"
            $invoke_graph_params["Body"] = $provisioning_body | ConvertTo-Json -Depth 10
            $invoke_graph_params["OutputType"] = "PSObject"

            # Invoke the provisioning request
            $r = Invoke-MgGraphRequest @invoke_graph_params

        } Catch {
            Write-Error $_

        }
    } End {
        $r
    
    }
}