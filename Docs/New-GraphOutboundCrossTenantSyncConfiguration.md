# New-GraphOutboundCrossTenantSyncConfiguration

## Overview

`New-GraphOutboundCrossTenantSyncConfiguration` is a PowerShell function to create a new outbound cross-tenant sync configuration. It's designed to set up sync configurations for tenants in Entra ID.

## Key Features

- Creates outbound cross-tenant sync configurations.
- Enables automatic user consent for sync operations, which is optional and true by default.
- Option to return the current settings after enabling the configuration.

## Parameters

- **TenantId (Mandatory)**: ID of the target tenant.
- **TenantName (Mandatory)**: Name of the target tenant.
- **EnableAutomaticUserConsent (Optional)**: Whether to enable automatic user consent for outbound sync. Default is true.
- **PassThru (Optional)**: If specified, returns the current settings post configuration.

## Usage Examples

```powershell
New-GraphOutboundCrossTenantSyncConfiguration -TenantId "00000000-0000-0000-0000-000000000000" -TenantName "contoso.onmicrosoft.com" -EnableAutomaticUserConsent $true
```

```powershell
New-GraphOutboundCrossTenantSyncConfiguration -TenantId "00000000-0000-0000-0000-000000000000" -TenantName "contoso.onmicrosoft.com" -EnableAutomaticUserConsent $true -PassThru | Format-List
```

## Function Operation

1. **Initialization**: Sets the error action preference and predefines parameters for creating and checking the sync configuration.
2. **Process**: Checks if an existing policy or configuration already exists. If not, it creates a new sync policy and configuration. A service principal ID for the sync is retrieved, with a timeout mechanism for confirmation.
3. **End**: Optionally returns the current settings, including the service principal ID and application ID, if `PassThru` is used.

## Output

- If `PassThru` is used, it outputs a custom object with details about the created service principal and application IDs.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/20/2023
- **Version**: 0.0.1
- **Name**: New-GraphOutboundCrossTenantSyncConfiguration

## Version History

- 0.0.1: Alpha Release - 11/20/2023 - Gabe Delaney
