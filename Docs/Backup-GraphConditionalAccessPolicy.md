# Backup-GraphConditionalAccessPolicy

## Overview

The `Backup-GraphConditionalAccessPolicy` function is designed to export Microsoft Entra Identity Conditional Access Policies into JSON format. It aids in preserving policy configurations for future reference or recovery purposes.

## Dependencies

- Requires PowerShell 5.1 or later.
- Microsoft Graph PowerShell SDK must be installed.

## Parameters

- **ConditionalAccessPolicyId** (Mandatory): Identifier of the Conditional Access Policy to be backed up.
- **Path** (Mandatory): File system path where the backup file will be stored.

## Usage Examples

```powershell
Backup-GraphConditionalAccessPolicy -ConditionalAccessPolicyId "00000000-0000-0000-0000-000000000000" -Path "C:\temp"
```

## Function Operation

1. **Initialization**: Sets up default parameters for the file path and JSON conversion depth.
2. **Backup Process**:
   - Iterates through each provided Conditional Access Policy ID.
   - Retrieves the policy using `Get-mgIdentityConditionalAccessPolicy`.
   - Generates a file name from the policy's display name.
   - Converts the policy details to JSON and saves the file to the specified path.
3. **End**: Completes the backup process for each policy ID.

## Outputs

- Creates JSON files with the details of the backed-up Conditional Access Policies.

## Additional Information

- **Author**: Gabriel Delaney
- **Date**: 11/11/2023
- **Version**: 0.0.1
- **Function Name**: Backup-GraphConditionalAccessPolicy

### Version History

- 0.0.1: Alpha Release - 11/09/2023 - Gabe Delaney
