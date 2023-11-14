# Restore-GraphConditionalAccessPolicy

## Overview

`Restore-GraphConditionalAccessPolicy` is a PowerShell function designed to restore conditional access policies from JSON files. It is particularly useful for reinstating policies backed up using `Backup-GraphConditionalAccessPolicy`, and for transferring policies between different Microsoft 365 tenants.

## Key Features

- Restores conditional access policies from JSON backups.
- Facilitates policy transfer between tenants.
- Handles specific JSON configurations required for policy restoration.

## Parameters

- **Path (Mandatory)**: The path to the JSON file containing the conditional access policy.
- **State (Optional)**: Specifies the state of the policy after restoration. Valid options are Enabled, Disabled, enabledForReportingButNotEnforced, and Current.
- **NewDisplayName (Optional)**: Assigns a new display name to the restored policy. If not specified, defaults to the original name appended with "(RESTORED)".
- **PassThru (Optional)**: If used, returns the response from the Graph API.

## Usage Examples

```powershell
Restore-GraphConditionalAccessPolicy -Path .\policy.json -State Enabled -PassThru
```

```powershell
Restore-GraphConditionalAccessPolicy -Path .\policy.json -State Disabled
```

```powershell
Restore-GraphConditionalAccessPolicy -Path .\policy.json -State Current -NewDisplayName "My New Policy"
```

## Function Operation

1. **Initialization**: Sets up the parameters required for the Graph API request.
2. **Policy Restoration**:
   - Reads and modifies the JSON file based on input parameters.
   - Updates the policy's display name and state as needed.
   - Sends a Graph API request to restore the policy.
3. **Error Handling and Output**: Manages potential errors and returns the Graph API response when the `PassThru` parameter is used.

## Output

- Returns a hashtable containing the Graph API response if the `PassThru` switch is used.

## Additional Information

- **Author**: Gabe Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/11/2023
- **Version**: 0.0.1
- **Name**: Restore-GraphConditionalAccessPolicy

## Version History

- 0.0.1: Alpha Release - 11/11/2023 - Gabe Delaney
