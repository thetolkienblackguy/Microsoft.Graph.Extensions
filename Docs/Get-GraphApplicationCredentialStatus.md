# Get-GraphApplicationCredentialStatus

## Overview

`Get-GraphApplicationCredentialStatus` is a PowerShell function for obtaining the expiration status of secrets and certificates for Entra ID applications. It can target all applications, a specific one, or filter by secrets or certificates.

## Key Features

- Retrieves expiration dates for application credentials.
- Options to filter by secrets, certificates, or include all applications.
- Customizable expiration threshold with a default of 30 days.

## Parameters

- **ApplicationId (Mandatory)**: The ID(s) of the application(s) to check.
- **SecretsOnly (Optional)**: Returns only secrets when specified.
- **CertificatesOnly (Optional)**: Returns only certificates when specified.
- **All (Optional)**: Returns all applications when specified.
- **ExpiresInDays (Optional)**: Specifies the number of days until expiration to consider. Default is 30 days.

## Usage Examples

```powershell
Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -SecretsOnly
```

```powershell
Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -CertificatesOnly
```

```powershell
Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -ExpiresInDays 60
```

```powershell
Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -All
```

## Function Operation

1. **Initialization**: Sets up parameters and computes the expiration date threshold.
2. **Processing**: Retrieves applications and their credentials, filtering based on parameters. It then creates a custom object for each credential with expiration information.
3. **Output**: Returns a sorted list of credential statuses, including days until expiration and whether they are expired.

## Output

- A sorted list of objects containing credential expiration details for the specified Entra ID applications.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/16/2023
- **Version**: 0.0.1
- **Name**: Get-GraphApplicationCredentialStatus

## Version History

- 0.0.1: Alpha Release - 11/16/2023 - Gabe Delaney
