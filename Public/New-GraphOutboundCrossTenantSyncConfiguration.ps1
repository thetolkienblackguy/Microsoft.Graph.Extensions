Function New-GraphOutboundCrossTenantSyncConfiguration {
    <#
        .DESCRIPTION
        Creates a new outbound cross-tenant sync configuration

        .SYNOPSIS
        Creates a new outbound cross-tenant sync configuration

        .PARAMETER TenantId
        The tenant ID of the target tenant

        .PARAMETER TenantName
        The tenant name of the target tenant

        .PARAMETER EnableAutomaticUserConsent
        This parameter specifies whether to enable automatic user consent for outbound cross-tenant sync. The default value is $true.

        .PARAMETER PassThru
        This parameter specifies whether to return the current settings after enabling outbound cross-tenant sync. The default value is $false.

        .EXAMPLE
        New-GraphOutboundCrossTenantSyncConfiguration -TenantId "00000000-0000-0000-0000-000000000000" -TenantName "contoso.onmicrosoft.com" -EnableAutomaticUserConsent $true

        .EXAMPLE
        New-GraphOutboundCrossTenantSyncConfiguration -TenantId "00000000-0000-0000-0000-000000000000" -TenantName "contoso.onmicrosoft.com" -EnableAutomaticUserConsent $true -PassThru | Format-List

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
        Name: New-GraphOutboundCrossTenantSyncConfiguration 

        Version History:
        0.0.1 - Alpha Release - 11/20/2023 - Gabe Delaney 
    
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId,
        [Parameter(Mandatory=$true)]
        [string]$TenantName,
        [Parameter(Mandatory=$false)]
        [boolean]$EnableAutomaticUserConsent = $true,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru

    )
    Begin {
        # Set the error action preference
        $ErrorActionPreference = "Stop"

        # Create an output object
        $output_obj = [ordered]@{}
        $output_obj["TenantId"] = $tenantId
        $output_obj["TenantName"] = $tenantName

        # New-MgPolicyCrossTenantAccessPolicyPartner parameters
        $new_sync_params = @{}
        $new_sync_params["TenantId"] = $tenantId
        $new_sync_params["automaticUserConsent"] = @{}
        $new_sync_params["automaticUserConsent"]["OutboundAllowed"] = $enableAutomaticUserConsent

        # Get-MgPolicyCrossTenantAccessPolicyPartner parameters
        $get_sync_params = @{}
        $get_sync_params["CrossTenantAccessPolicyConfigurationPartnerTenantId"] = $tenantId
        $get_sync_params["ErrorAction"] = "SilentlyContinue"

        # Invoke-MgInstantiateApplicationTemplate parameters
        $invoke_instantiate_params = @{}
        $invoke_instantiate_params["DisplayName"] = $tenantName
        $invoke_instantiate_params["ApplicationTemplateId"] = "518e5f48-1fc8-4c48-9387-9fdf28b0dfe7"
    } Process {
        Try {
            # Check if an outbound cross-tenant sync already exist
            $policy_partner = Get-MgPolicyCrossTenantAccessPolicyPartner @get_sync_params
            If ($policy_partner) {
                Write-Warning -Message "An outbound tenant access policy already exist for $tenantId. No changes will be made to the existing policy"

            } Else {
                # Enable inbound cross-tenant sync
                New-MgPolicyCrossTenantAccessPolicyPartner @new_sync_params | Out-Null

            }
            # Check if a service principal already exist for the cross-tenant sync
            $configuration = Get-MgServicePrincipal -Filter "displayName eq '$tenantName'"
            If ($configuration) {
                Write-Warning -Message "An outbound cross-tenant synchronization coniguration already exist for $tenantName. No changes will be made to the existing configuration"
                Break

            } Else {
                # Create a configuration for the cross-tenant sync
                Invoke-MgInstantiateApplicationTemplate @invoke_instantiate_params | Out-Null

            }
            # Create time out variable
            $time_out = Get-Date

            # Get the service principal ID for the cross-tenant sync
            Do {
                $service_principal = Get-MgServicePrincipal -Filter "displayName eq '$tenantName'"

            } While (!$service_principal -or $time_out.AddMinutes(1) -gt (Get-Date))
            If (!$service_principal) {
                Write-Error -Message "Unable to confirm the creation of $tenantName configuration.  The request has timed out" -ErrorAction Stop

            }
        } Catch {
            Write-Error -Message $_.Exception.Message -ErrorAction Stop

        }
    } End {
        # Return the current settings
        If ($passThru) {
            $output_obj["ServicePrincipalId"] = $service_principal.Id
            $output_obj["AppId"] = $service_principal.AppId
            [pscustomobject]$output_obj

        }        
    }
}