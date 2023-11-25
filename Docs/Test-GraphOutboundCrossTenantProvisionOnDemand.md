# Test-GraphOutboundCrossTenantProvisionOnDemand

## Overview

`Test-GraphOutboundCrossTenantProvisionOnDemand` is a PowerShell function designed to initiate on-demand provisioning in a Microsoft Entra ID cross-tenant synchronization scenario.

## Key Features

- Initiates on-demand provisioning for a specified user or group object in a cross-tenant setup.
- Utilizes Azure2Azure outbound synchronization rules.
- Invokes a Graph API request to process the provisioning task.

## Parameters

- **ServicePrincipalId (Mandatory)**: The service principal ID associated with the outbound synchronization.
- **ObjectId (Mandatory)**: The unique identifier of the user or group object to be provisioned.
- **ObjectTypeName (Mandatory)**: Specifies the type of object (User or Group) to be provisioned.

## Function Operation

1. **Initialization**: Sets default parameters and prepares the provisioning body based on the provided object ID and type.
2. **Process**:
   - Retrieves the Azure2Azure outbound sync rule ID.
   - Constructs the request body for on-demand provisioning.
   - Sends a POST request to the Microsoft Graph API to initiate the provisioning process.
3. **End**: Returns the response from the provisioning request.

## Usage Example

```powershell
Test-GraphOutboundCrossTenantProvisionOnDemand -ServicePrincipalId "ServicePrincipalIdValue" -ObjectId "ObjectIdValue" -ObjectTypeName "User"
```

## Output

- Returns the result of the provisioning request, which includes details of the provisioning operation.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/20/2023
- **Version**: 0.0.1
- **Name**: Test-GraphOutboundCrossTenantConnection

## Version History

- 0.0.1: Alpha Release - 11/20/2023 - Gabe Delaney
