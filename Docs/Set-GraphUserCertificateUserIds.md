# Set-GraphUserCertificateUserIds

## Overview

`Set-GraphUserCertificateUserIds` is a PowerShell function designed to manage certificate user IDs for users in Entra Id. It allows for setting, appending, and modifying certificate user IDs based on either direct input values or certificate files.

## Key Features

- Sets or appends certificate user IDs for Entra Id users.
- Handles both direct values and certificate file paths.
- Supports multiple certificate mapping types.

## Parameters

- **UserId (Mandatory)**: The user's object ID or user principal name for which to set the certificate user IDs.
- **CertificateMapping (Mandatory)**: Specifies the type of certificate mapping. Valid options include PrincipalName, RFC822Name, X509SKI, and X509SHA1PublicKey.
- **Value (Mandatory)**: The value to set as the certificate user ID. Required when the parameter set is "Value".
- **CertificatePath (Mandatory)**: Path to the certificate file. Required when the parameter set is "Path".
- **Append (Optional)**: Appends the certificate user ID to existing IDs instead of overwriting.
- **PassThru (Optional)**: Returns the user object after updating the certificate user IDs.

## Usage Examples

```powershell
Set-GraphUserCertificateUserIds -UserId "John.Doe@contoso.com" -CertificateMapping "PrincipalName" -Value "john.doe@contoso.com" -PassThru
```

```powershell
Set-GraphUserCertificateUserIds -UserId "John.Doe@contoso.com" -CertificateMapping "PrincipalName" -CertificatePath "C:\Users\John.Doe\Documents\John.Doe.cer"
```

## Function Operation

1. **Initialization**: Retrieves user information from Entra Id and prepares certificate mapping data.
2. **Processing**:
   - Handles both direct value input and certificate file processing.
   - Supports appending to existing certificate user IDs.
   - Limits the total number of certificate user IDs to five per user.
3. **Updating Entra Id**: Sends the updated information to Entra Id using Graph API requests.

## Output

- Optionally returns the updated user object with the new certificate user IDs.

## Additional Information

- **Author**: Gabriel Delaney | <gdelaney@phzconsulting.com>
- **Date**: 11/14/2023
- **Version**: 0.0.1
- **Name**: Set-GraphUserCertificateUserIds

## Version History

- 0.0.1: Alpha Release - 11/14/2023 - Gabe Delaney
