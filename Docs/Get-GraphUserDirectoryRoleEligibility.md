# Get-GraphUserDirectoryRoleEligibility.md

`Get-GraphUserDirectoryRoleEligibility` is a PowerShell function that retrieves the directory role eligibility for a user using the Microsoft Graph API.

## Synopsis

This function gets the directory role eligibility for a user.

## Syntax

```powershell
Get-GraphUserDirectoryRoleEligibility
  -UserId <string[]>
```

## Description

The `Get-GraphUserDirectoryRoleEligibility` function provides a way to retrieve the directory role eligibility for a specified user or users. It uses the Microsoft Graph API to fetch the role eligibility schedule instances and returns detailed information about the roles the user is eligible for.

## Parameters

- `-UserId <string[]>`
  Specifies the UserId. Aliases: Id, UserPrincipalName, UPN.

## Examples

### Example 1: Get directory role eligibility for a user
```powershell
Get-GraphUserDirectoryRoleEligibility -UserId "jdoe@contoso.com"
```

### Example 2: Get directory role eligibility for multiple users
```powershell
"user1@contoso.com", "user2@contoso.com" | Get-GraphUserDirectoryRoleEligibility
```

### Example 3: Get directory role eligibility and format as a table
```powershell
Get-GraphUserDirectoryRoleEligibility -UserId "jdoe@contoso.com" | Format-Table DisplayName, Id, AssignmentState, UserPrincipalName
```

---

*Disclaimer: This README was generated by Claude AI 3.5 Sonnet.*
