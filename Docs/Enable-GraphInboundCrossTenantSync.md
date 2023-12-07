# Enable-GraphInboundCrossTenantSync

## Overview

`Enable-GraphInboundCrossTenantSync` is a PowerShell function designed to facilitate the activation of inbound cross-tenant synchronization in Microsoft Entra Identity Governance. This functionality is pivotal for organizations managing interactions between multiple tenants.

## Key Features

- Enables inbound synchronization for a specified tenant.
- Provides an option to enable automatic user consent for inbound cross-tenant sync.

## Parameters

- **TenantId (Mandatory)**: Identifies the tenant for which to enable inbound cross-tenant sync.
- **EnableAutomaticUserConsent (Optional)**: Dictates whether to enable automatic user consent for the inbound sync. Defaults to `$true`.
- **PassThru (Optional)**: Determines if the function returns the current settings post-enablement. Default is `$false`.

## Usage Examples

```powershell
Enable-GraphInboundCrossTenantSync -TenantId "contoso.onmicrosoft.com" -EnableAutomaticUserConsent $true -PassThru
```

## Function Operation

1. **Initialization**: Sets up parameters for creating a new cross-tenant access policy partner with automatic user consent configuration.
2. **Processing**: Executes the command to enable inbound cross-tenant synchronization with the specified settings.
3. **Output**: If `-PassThru` is used, it returns the current settings, showing the status of inbound synchronization for the tenant.

## Output

- Optionally outputs the current settings regarding inbound cross-tenant sync if the `-PassThru` switch is utilized.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/20/2023
- **Version**: 0.0.1
- **Name**: Enable-GraphInboundCrossTenantSync

## Version History

- 0.0.1: Alpha Release - 11/11/2023 - Gabe Delaney
