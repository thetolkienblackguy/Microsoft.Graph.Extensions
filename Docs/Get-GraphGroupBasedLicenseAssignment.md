# Get-GraphGroupBasedLicenseAssignment

## Overview

The `Get-GraphGroupBasedLicenseAssignment` function is designed to retrieve information about licenses assigned to groups within Microsoft 365 environments. It is particularly useful for administrators looking to monitor and manage group-based license assignments.

## Key Features

- Retrieves licenses assigned to specific groups.
- Supports querying by SKU ID or retrieving all assigned licenses.
- Integrates with the Microsoft Graph API for data retrieval.

## Parameters

- **SkuId (Mandatory)**: The SKU ID of the license. This parameter can be a single SKU ID or an array of SKU IDs.
- **All (Mandatory)**: If specified, the function returns all licenses assigned to groups.

## Usage Examples

```powershell
Get-GraphGroupBasedLicenseAssignment -SkuId "6fd2c87f-b296-42f0-b197-1e91e994b900"
```

```powershell
Get-MgSubscribedSku | Get-GraphGroupBasedLicenseAssignment
```

```powershell
Get-GraphGroupBasedLicenseAssignment -All
```

## Function Operation

1. **Initialization**: Checks and retrieves cached subscription SKU information if available.
2. **License Retrieval**:
   - If 'All' is specified, retrieves all SKU IDs from the cached data.
   - Fetches group information for specified or all SKU IDs.
3. **Data Processing**: Creates and returns objects with detailed group and license information.

## Output

- Returns objects containing detailed information about group-based license assignments.

## Additional Information

- **Author**: Gabe Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/14/2023
- **Version**: 0.0.1
- **Name**: Get-GraphGroupBasedLicenseAssignment

## Version History

- 0.0.1: Alpha Release - 11/14/2023 - Gabe Delaney
