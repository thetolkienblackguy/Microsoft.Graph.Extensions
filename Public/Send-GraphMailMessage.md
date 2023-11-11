# Send-GraphMailMessage

## Overview
The `Send-GraphMailMessage` function greatly simplifies the process of sending emails using the Microsoft Graph API. This function dynamically constructs the email body and efficiently manages other email components such as recipients and attachments. It offers a more user-friendly and streamlined approach to sending emails, especially when compared to the more manual and complex methods required with the vanilla Microsoft Graph SDK.

## Enhancements Over Vanilla Graph SDK
- **Dynamic Email Composition**: Automatically handles the creation and formatting of the email body, subject, and other components.
- **Simplified Attachment Handling**: Utilizes the `Set-GraphAttachmentArray` function to easily manage email attachments.
- **Efficient Recipient Management**: Employs the `Set-GraphRecipientArray` function to handle multiple recipients, CCs, and BCCs effortlessly.

## Private Functions
- **Set-GraphRecipientArray**: This private function takes a list of email addresses and converts them into a format suitable for the Microsoft Graph API. It ensures that the 'toRecipients', 'ccRecipients', and 'bccRecipients' fields in the email object are correctly structured.
- **Set-GraphAttachmentArray**: This function is used for handling file attachments. It accepts file paths, converts them into a format required by the Graph API, and attaches them to the email. This simplifies the process of attaching files to an email, which can be complex when using the Graph SDK directly.

## Dependencies
- PowerShell 5.1 or higher.
- Microsoft Graph PowerShell SDK.
- An authenticated session with Microsoft Graph.

## Parameters
- **To** (Mandatory): Recipient(s) of the email.
- **Subject** (Mandatory): Subject line of the email.
- **Body** (Mandatory): Body content of the email.
- **From** (Mandatory): Sender's email address.
- **Cc** (Optional): Carbon copy recipient(s).
- **Bcc** (Optional): Blind carbon copy recipient(s).
- **Attachments** (Optional): File attachment(s) for the email.
- **PassThru** (Optional): Returns the response object from the Graph API call.

## Usage Examples
```powershell
Send-GraphMailMessage -To "john.doe@contoso.com" -From "jane.doe@contoso.com" -Subject "Test" -Body "This is a test"
```

```powershell
Send-GraphMailMessage -To "john.doe@contoso.com" -From "jane.doe@contoso.com" -Subject "Test" -Body "This is a test" -Attachments "C:\\Temp\\test.txt"
```

## Function Operation
1. **Email Composition**:
   - Creates a hashtable to store the email message.
   - Dynamically constructs the email message, including subject, body, recipients, CC, BCC, and attachments.
   - Converts the message into a JSON format for the Graph API request.

2. **Sending the Email**:
   - Configures the `Invoke-MgGraphRequest` parameters with the appropriate URI, method, and body content.
   - Sends the email using the Microsoft Graph API.

3. **Output**:
   - If the `-PassThru` switch is used, returns the response object from the Graph API call.

## Outputs
- Optionally returns a response object from the Graph API if the `-PassThru` switch is used.

## Notes
- **Author**: Gabe Delaney | gdelaney@phzconsulting.com
- **Version**: 0.0.1
- **Date**: 11/09/2023
- **Function Name**: Send-GraphMailMessage

### Version History
- 0.0.1: Alpha Release - 11/09/2023 - Gabe Delaney