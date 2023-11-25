# Test-GraphOutboundCrossTenantConnection

## Overview

`Test-GraphOutboundCrossTenantConnection` is a PowerShell function designed to verify the functionality of Microsoft Entra ID cross-tenant synchronization credentials.

## Key Features

- Tests the Microsoft Entra ID cross-tenant synchronization credentials.
- Verifies if the connection and credentials between tenants are valid.
- Provides a boolean output indicating the success or failure of the credential test.

## Parameters

- **TenantId (Mandatory)**: The tenant ID of the target tenant.
- **ServicePrincipalId (Mandatory)**: The service principal ID of the target tenant.

## Usage Example

```powershell
Test-GraphOutboundCrossTenantConnection -TenantId "00000000-0000-0000-0000-000000000000" -ServicePrincipalId "00000000-0000-0000-0000-000000000000"
```

## Function Operation

1. **Initialization**: Sets up parameters for invoking a Graph request to test the credentials.
2. **Process**: Executes the request to validate credentials. If successful, sets `credentials_valid` to `true`; otherwise, it's set to `false`.
3. **End**: Outputs an object containing tenant and service principal IDs, and the validity status of the credentials.

## Output

- Outputs an object with the fields `TenantId`, `ServicePrincipalId`, and `CredentialsValid` (a boolean indicating if the credentials are valid).

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/20/2023
- **Version**: 0.0.1
- **Name**: Test-GraphOutboundCrossTenantConnection

## Version History

- 0.0.1: Alpha Release - 11/20/2023 - Gabe Delaney
