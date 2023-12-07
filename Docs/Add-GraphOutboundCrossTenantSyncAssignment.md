# Add-GraphOutboundCrossTenantSyncAssignment

## Overview

`Add-GraphOutboundCrossTenantSyncAssignment` is a PowerShell function designed to add an outbound cross-tenant sync assignment to a service principal in Microsoft Entra ID. This function is particularly useful for managing cross-tenant access for users or groups.

## Key Features

- Adds user or group assignments for cross-tenant synchronization.
- Targets specific service principals in the target tenant.

## Parameters

- **ServicePrincipalId (Mandatory)**: The identifier for the target tenant's service principal.
- **ObjectId (Mandatory)**: The object ID of the user or group to be added to the cross-tenant sync assignment.
- **PassThru (Optional)**: Determines whether to return the current settings post-assignment. Default is `$false`.

## Usage Examples

```powershell
Add-GraphOutboundCrossTenantSyncAssignment -ServicePrincipalId "00000000-0000-0000-0000-000000000000" -ObjectId "00000000-0000-0000-0000-000000000000" -PassThru
```

## Function Operation

1. **Initialization**: Prepares the parameters for Microsoft Graph API requests and sets error handling preferences.
2. **Processing**:
   - Retrieves the default access app role ID using a GET request.
   - Assigns the app role to the specified user or group via a POST request.
   - Handles potential errors, especially when an assignment already exists.

## Output

- Optionally returns the response from the Graph API if the `-PassThru` switch is used.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/22/2023
- **Version**: 0.0.1
- **Name**: Add-GraphOutboundCrossTenantSyncAssignment

## Version History

- 0.0.1: Alpha Release - 11/22/2023 - Gabe Delaney
