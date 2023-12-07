# New-GraphOutboundCrossTenantSyncJob

## Overview

`New-GraphOutboundCrossTenantSyncJob` is a PowerShell function designed to test and establish Microsoft Entra ID cross-tenant synchronization credentials. It primarily deals with setting up a synchronization job between different tenants.

## Key Features

- Tests and sets up cross-tenant synchronization credentials.
- Creates a new service principal synchronization job.
- Handles errors and conditions where a sync job already exists.

## Parameters

- **TenantId (Mandatory)**: The tenant ID of the target tenant.
- **ServicePrincipalId (Mandatory)**: The service principal ID of the target tenant.

## Usage Example

```powershell
New-GraphOutboundCrossTenantSyncJob -TenantId "00000000-0000-0000-0000-000000000000" -ServicePrincipalId "00000000-0000-0000-0000-000000000000"
```

## Function Operation

1. **Initialization**: Sets error action preference and initializes parameters for the service principal synchronization job and graph request.
2. **Process**: Attempts to create a new sync job. If a sync job already exists, it warns and proceeds. It then invokes a Graph request to save credentials.
3. **End**: Outputs the result of the sync job creation.

## Output

- Outputs the result of the synchronization job creation process.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/20/2023
- **Version**: 0.0.1
- **Name**: New-GraphOutboundCrossTenantSyncJob

## Version History

- 0.0.1: Alpha Release - 11/20/2023 - Gabe Delaney
