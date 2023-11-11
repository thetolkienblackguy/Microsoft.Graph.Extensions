# Get-GraphAccessToken 

## Overview
The `Get-GraphAccessToken` function retrieves an access token for the Microsoft Graph API. This token is crucial for authenticating requests to Microsoft Graph, a unified API endpoint for accessing Microsoft 365 services.

## Dependencies
- PowerShell 5.1 or higher.
- Internet connectivity for accessing Microsoft Graph API endpoints.

## Parameters
- **ClientId** (Mandatory): The client ID of the Azure AD application.
- **ClientSecret** (Mandatory): The client secret of the application. Accepts both plain strings and secure strings, facilitated by the `SecureStringTransformation` class.
- **TenantId** (Mandatory): The tenant ID associated with the Azure AD application.
- **AsPlainText** (Optional): If specified, the access token is returned as a plain text string.

## Usage Examples
```powershell
Get-GraphAccessToken -ClientId "your-client-id" -ClientSecret "your-client-secret" -TenantId "your-tenant-id"
```

```powershell
Get-GraphAccessToken -ClientId "your-client-id" -ClientSecret "your-client-secret" -TenantId "your-tenant-id" -AsPlainText
```

## Function Operation
1. **Initialization**:
   - Constructs the request body including grant type, resource, client ID, and client secret.
   - Utilizes the `SecureStringTransformation` class to accept the `ClientSecret` as either a secure string or a regular string, enhancing flexibility in handling sensitive data.

2. **Token Request**:
   - Prepares `Invoke-RestMethod` parameters to make a POST request to the Microsoft OAuth2 token endpoint.
   - Executes the REST method to retrieve the access token.

3. **Output**:
   - By default, returns the access token as a secure string.
   - If `-AsPlainText` is used, outputs the token as a plain text string.

## Outputs
- Outputs a `System.Security.SecureString` by default, or a `System.String` if `-AsPlainText` is specified.

## Notes
- **Author**: Gabe Delaney | gdelaney@phzconsulting.com
- **Version**: 0.0.1
- **Date**: 11/09/2023
- **Function Name**: Get-GraphAccessToken

### Version History
- 0.0.1: Alpha Release - 11/09/2023 - Gabe Delaney