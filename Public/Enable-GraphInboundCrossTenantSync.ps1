Function Enable-GraphInboundCrossTenantSync {
    <#
        .DESCRIPTION
        This function enables inbound cross-tenant sync for a tenant.

        .SYNOPSIS
        This function enables inbound cross-tenant sync for a tenant.

        .PARAMETER TenantId
        The tenant ID of the tenant to enable inbound cross-tenant sync for.

        .PARAMETER EnableAutomaticUserConsent
        This parameter specifies whether to enable automatic user consent for inbound cross-tenant sync. The default value is $true.

        .PARAMETER PassThru
        This parameter specifies whether to return the current settings after enabling inbound cross-tenant sync. The default value is $false.

        .EXAMPLE
        Enable-GraphInboundCrossTenantSync -TenantId "contoso.onmicrosoft.com" -EnableAutomaticUserConsent $true -PassThru

        .INPUTS
        System.String
        System.Boolean
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Object

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/20/2023
        Version: 0.0.1
        Name: Enable-GraphInboundCrossTenantSync

        Version History:
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney 
    
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId,
        [Parameter(Mandatory=$false)]
        [boolean]$EnableAutomaticUserConsent = $true,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru

    )
    Begin {
        # New-MgPolicyCrossTenantAccessPolicyPartner parameters
        $new_sync_params = @{}
        $new_sync_params["TenantId"] = $tenantId
        $new_sync_params["automaticUserConsent"] = @{}
        $new_sync_params["automaticUserConsent"]["inboundAllowed"] = $enableAutomaticUserConsent

    } Process {
        # Enable inbound cross-tenant sync
        New-MgPolicyCrossTenantAccessPolicyPartner @new_sync_params | Out-Null

    } End {
        # Return the current settings
        If ($passThru) {
            Get-MgPolicyCrossTenantAccessPolicyPartnerIdentitySynchronization -CrossTenantAccessPolicyConfigurationPartnerTenantId $tenantId | 
                Select-Object -Property TenantId, @{
                    Name="InboundSyncAllowed";Expression={
                        $_.UserSyncInbound.IsSyncAllowed
                    }
                }

        }        
    }
}