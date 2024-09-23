# Microsoft.Graph.Extensions

[![license MIT](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/thetolkienblackguy/Microsoft.Graph.Extensions/blob/main/LICENSE)
![Release v0.0.1 Alpha](https://img.shields.io/badge/Release-v0.0.1%20Alpha-blue)
[![Docs](https://img.shields.io/badge/Docs-GitHub-blue)](https://github.com/thetolkienblackguy/Microsoft.Graph.Extensions/tree/main/Docs)

## About

When Microsoft announced the deprecation of the MSOnline and AzureAD modules, I quickly transitioned to using the Microsoft Graph PowerShell SDK. While the transition wasn't difficult due to my familiarity with Microsoft Graph, I encountered several challenges. Many cmdlets didn't work as expected, some had bugs or weren't feature-complete, and numerous commands required complex JSON bodies to perform tasks - a particular pain point for those unfamiliar with REST APIs (I'm looking at you, Send-MgUserMail).

These experiences motivated me to create Microsoft.Graph.Extensions. I originally built this module for my own development work with clients, aiming to streamline automation processes. Over time, the module has continued to evolve - including multiple name changes. While some functions have become less useful as the official SDK has improved, new needs and use cases have emerged, driving further development.

The module remains very much centered around the use cases I encounter most frequently in my work. However, it has reached a stage where I believe it could be valuable to others facing similar challenges or looking to simplify their interactions with Microsoft Graph.

The Microsoft.Graph.Extensions PowerShell module provides extended and simplified functions that enhance the Microsoft Graph PowerShell SDK. This module is designed to streamline interactions with the Microsoft Graph API, offering a more user-friendly and efficient approach to common tasks.

## Overview

Think of the Microsoft.Graph.Extensions PowerShell module as a "mod" for the Microsoft Graph PowerShell SDK, much like mods you might find for PC games. This this module aims to provide quality-of-life improvements, boost usability, and introduce additional functionality that may be missing from the standard SDK. It is not a replacement for the standard SDK, but rather a complement that enhances its capabilities.

## Installation

To install the module directly from GitHub, use the following PowerShell commands:

```powershell
# Download the module
Invoke-WebRequest -Uri "https://github.com/thetolkienblackguy/Microsoft.Graph.Extensions/archive/main.zip" -OutFile "Microsoft.Graph.Extensions.zip"

# Extract the module
Expand-Archive -Path "Microsoft.Graph.Extensions.zip" -DestinationPath "C:\Temp"

# Move the module to the PowerShell modules folder
Move-Item -Path "C:\Temp\Microsoft.Graph.Extensions-main" -Destination "$($env:PSModulePath.Split(';')[0])\Microsoft.Graph.Extensions"

# Import the module
Import-Module Microsoft.Graph.Extensions
```

## Key Features

**Simplified Email Sending**
The `Send-GraphMailMessage` function greatly simplifies the process of sending emails via Graph API. Unlike the standard SDK, which requires complex hashtables for recipients and attachments, this function offers a more intuitive interface.

**Enhanced Graph API Interactions**
Functions like `Get-GraphGroupMember` and `Get-GraphDirectoryRole` provide streamlined ways to interact with common Graph API endpoints. These functions often include additional features not present in the vanilla SDK, such as recursive group member retrieval.

**Pipeline Support**
Many functions in this module support pipeline input, a feature often lacking in the vanilla SDK. This enables more efficient and PowerShell-idiomatic ways of chaining commands and processing data.

**Object Flattening**
Complex objects, such as Conditional Access Policies, can be flattened for easier analysis and manipulation. This feature simplifies working with nested data structures.

**Advanced Filtering**
Perform advanced filters without the need to explicitly define the count variable or consistency level. This simplifies query construction and execution, including support for negation operators.

**Enhanced Licensing Management**
Simplifies the process of finding and managing groups with assigned licenses, providing an easier way to handle license assignments at scale.

## Usage Notes

- This module is designed to complement, not replace, the official Microsoft Graph PowerShell SDK.
- It's particularly useful for scenarios where the standard SDK functions require verbose or complex input structures.
- As a work in progress, new functions are added based on specific needs and use cases. Contributions and suggestions are welcome.

## Examples

Simplified email sending:
```powershell
# Send an email with an intuitive command structure, including the From address
Send-GraphMailMessage -From "sender@example.com" -To "recipient@example.com" -Subject "Hello" -Body "This is a test email."
```

Recursive group member retrieval:
```powershell
# Get all members of a group, including members of nested groups
Get-GraphGroupMember -GroupId "00000000-0000-0000-0000-000000000000" -Recursive
```

Pipeline support for bulk operations:
```powershell
# Retrieve members of multiple groups in one command
Get-MgGroup -Filter "startsWith(displayName,'IT')" | Get-GraphGroupMember
```

Flattening complex objects:
```powershell
# Get a simplified view of Conditional Access Policies
Get-GraphConditionalAccessPolicy -FlattenOutput
```

Advanced filtering with negation:
```powershell
# Find all users whose job title is not 'Manager'
Get-GraphUser -Filter "not startsWith(jobTitle,'Manager')"
```

Finding groups with licensing:
```powershell
# Retrieve all groups that have licenses assigned
Get-GraphGroupBasedLicenseAssignment
```

## Dependencies

### Required
- **Microsoft.Graph.Authentication**: This module is required for authentication with Microsoft Graph.

### Recommended
- **Microsoft.Graph**: While not strictly required, it is strongly recommended to use Microsoft.Graph.Extensions alongside the full Microsoft.Graph module. Microsoft.Graph.Extensions is designed to enhance and simplify certain operations, not to replace the core functionality provided by Microsoft.Graph.

To install the dependencies, you can use the following commands:

```powershell
# Install required module
Install-Module -Name Microsoft.Graph.Authentication -Force

# Install recommended module
Install-Module -Name Microsoft.Graph -Force
```

Note: Microsoft.Graph.Extensions is not a replacement for the Microsoft.Graph module. It is designed to work in conjunction with it, providing additional functionality and simplified workflows for common tasks.

## Conclusion

The Microsoft.Graph.Extensions module aims to make working with the Microsoft Graph API more accessible and efficient. While it's tailored to specific needs, it can be a valuable tool for anyone looking to streamline their Graph API interactions in PowerShell.

## Important Notes

- This module is currently in Alpha status. It is under active development and may undergo significant changes.
- As with any Alpha release, users should exercise caution and thoroughly test the module in a non-production environment before considering it for production use.
- While efforts are made to ensure stability and reliability, unexpected behaviors may occur.
- Users are encouraged to report any issues or unexpected behaviors to help improve the module.
- Regular updates may be released, so it's recommended to check for the latest version frequently.
- Functions may be removed or modified without notice or become obsolete due to changes in the Microsoft Graph PowerShell SDK.


---

*Disclaimer: This README was generated by Claude AI 3.5 Sonnet.*