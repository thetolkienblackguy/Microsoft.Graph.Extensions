# Microsoft.Graph.Extensions

## Introduction

**Microsoft.Graph.Extensions** is a PowerShell module designed to extend and enhance the functionality provided by the Microsoft Graph SDK. Built on top of the Microsoft.Graph.Authentication sub-module. If you're familiar at all with PC gaming, you probably heard of mods. In that sense, this module is more of a mod for the PowerShell Microsoft Graph SDK than a standalone module: it works on top of an established foundation, adding enhancements, quality-of-life improvements, and addressing certain limitations.

## Purpose

This module was initially developed to address specific needs in my daily operations, but it is designed to be flexible and useful for a broader audience. By simplifying complex tasks and providing additional features, Microsoft.Graph.Extensions aims to make working with the Graph SDK more efficient and effective.

## Features

- **Enhanced Cmdlets**: The module includes replacements for some standard SDK cmdlets that provide improved functionality and reliability. For instance, it simplifies operations like sending emails, which often require complex hashtables to handle multiple recipients or attachments.
- **ShouldProcess Support**: Full support for `-WhatIf` and `-Confirm` parameters, allowing for safe testing of commands.
- **Pipeline Input**: Support for pipeline input from both within the module and from standard Graph SDK cmdlets, enhancing workflow efficiency.

## Status

The module is currently in Alpha. While it has been used in production with clients, it is still under active development. Users should be aware of its ongoing evolution and potential changes.

## Installation

Currently, the module is available on GitHub. You can install it by cloning the repository and importing the module manually.

```powershell
# Clone the repository
git clone https://github.com/thetolkienblackguy/Microsoft.Graph.Extensions.git

```

## Usage Example & Comparison

### Sending Email

Here is a basic example demonstrating how to use the module to send an email with multiple recipients and attachments, highlighting the ease of use compared to standard methods.

```powershell
# Send an email with multiple recipients and attachments using the Microsoft.Graph.Extensions module
Send-GraphMailMessage -Recipients "user1@contoso.com", "user2@contoso.com" -Subject "Hello World" -Body "This is a test email" -Attachments @("C:\path\to\file1.txt", "C:\path\to\file2.txt")

# Send an email with just one recipient and attachment using the PowerShell Microsoft Graph SDK module
Import-Module Microsoft.Graph.Users.Actions
$params = @{
 Message = @{
  Subject = "Meet for lunch?"
  Body = @{
   ContentType = "Text"
   Content = "The new cafeteria is open."
  }
  ToRecipients = @(
   @{
    EmailAddress = @{
     Address = "meganb@contoso.onmicrosoft.com"
    }
   }
  )
  Attachments = @(
   @{
    "@odata.type" = "#microsoft.graph.fileAttachment"
    Name = "attachment.txt"
    ContentType = "text/plain"
    ContentBytes = "SGVsbG8gV29ybGQh"
   }
  )
 }
}
# A UPN can also be used as -UserId.
Send-MgUserMail -UserId $userId -BodyParameter $params


```

### Get Entra Id Groups with Assigned License

Need to find all groups in your tenant with assigned licenses?

```PowerShell

# Using the Microsoft.Graph.Extensions module which uses server-side filtering


# Microsoft's recommended approach which uses client-side filtering which is signficantly slower

# Get all groups with assigned licenses
$groups = Get-MgGroup -All -Property Id, MailNickname, DisplayName, GroupTypes, Description, AssignedLicenses | Where-Object {$_.AssignedLicenses -ne $null }

# Process each group
$groupInfo = foreach ($group in $groups) {
    # For each group, get the SKU part numbers of the assigned licenses
    $skuPartNumbers = foreach ($skuId in $group.AssignedLicenses.SkuId) {
        $subscribedSku = Get-MgSubscribedSku | Where-Object { $_.SkuId -eq $skuId }
        $subscribedSku.SkuPartNumber
    }

# Create a custom object with the group's object ID, display name, and license SKU part numbers
    [PSCustomObject]@{
        ObjectId = $group.Id
        DisplayName = $group.DisplayName
        Licenses = $skuPartNumbers -join ', '
    }
}

$groupInfo


```

## Suggestions and Feedback

I am open to suggestions for new functions or improvements that you might find useful. Your feedback is invaluable as it helps guide the ongoing development of the module. Please feel free to open an issue or submit a pull request on the GitHub repository.

## Contributing

Contributions are welcome! If you have ideas, bug reports, or feature requests, please open an issue or submit a pull request on the GitHub repository.

## License

This project is licensed under the MIT License

## Contact

For any questions or suggestions, you can reach out via the GitHub repository.

---

Thank you for using Microsoft.Graph.Extensions. Let's make the Graph SDK experience more efficient and productive.

**Gabriel**
Owner, Phoenix Horizons LLC
