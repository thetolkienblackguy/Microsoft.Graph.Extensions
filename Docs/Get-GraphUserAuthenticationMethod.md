# Get-GraphUserAuthenticationMethod

## Overview

`Get-GraphUserAuthenticationMethod` is a PowerShell function designed to retrieve authentication methods for users within Entra Id. It allows for specifying individual users or an array of users and supports filtering and selecting specific authentication methods.

## Key Features

- Retrieves authentication methods for specified users in Entra Id.
- Supports a variety of authentication methods, offering flexibility in querying.
- Enables user-specific or bulk user queries.

## Parameters

- **UserId (Mandatory)**: The user or users for whom to retrieve authentication methods. Can be a single user or an array of users.
- **Method (Optional)**: Specifies the authentication method to retrieve. If not specified, all methods are returned.
- **Filter (Optional)**: Applies a filter when retrieving users, passed to `Get-MgUser`.
- **All (Optional)**: When used, retrieves authentication methods for all users.

## Usage Examples

```powershell
Get-GraphUserAuthenticationMethod -UserId "jdoe@contoso.com"
```

```powershell
Get-GraphUserAuthenticationMethod -UserId "jdoe@contoso.com" -Method "AuthenticatorApp"
```

```powershell
Get-MgUser -Filter "startswith(UserPrincipalName, 'jdoe')" | Get-GraphUserAuthenticationMethod
```

## Function Process

1. **User Query**: If the `All` parameter is specified, all users are retrieved based on the provided filter.
2. **Method Retrieval**: Iterates through each user to gather their authentication methods.
3. **Data Processing**: Compiles authentication methods and relevant information into a structured list.

## Output

- A list of custom objects, each representing a user's authentication method.

## Additional Information

- **Author**: Gabe Delaney | <gdelaney@phzconsulting.com>
- **Version**: 0.0.1
- **Date**: 11/12/2023
- **Name**: Get-GraphUserAuthenticationMethod

### Version History

- 0.0.1: Alpha Release - 11/12/2023 - Gabe Delaney
