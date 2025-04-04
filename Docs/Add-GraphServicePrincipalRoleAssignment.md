# Add-GraphServicePrincipalAppRoleAssignment.md

`Add-GraphServicePrincipalAppRoleAssignment` is a PowerShell function that adds an app role assignment to a service principal using the Microsoft Graph API.

## Synopsis

This function adds an app role assignment to a service principal.

## Syntax

```powershell
Add-GraphServicePrincipalAppRoleAssignment
  -ServicePrincipalId <guid>
  -ObjectId <guid>
  -AppRoleId <guid>
  [-PassThru]
```

## Description

The `Add-GraphServicePrincipalAppRoleAssignment` function provides a way to assign an app role to a service principal using the Microsoft Graph API. It takes the service principal ID, the object ID to assign the role to, and the app role ID as parameters.

## Parameters

- `-ServicePrincipalId <guid>`
  The ID of the service principal to add the app role assignment to. Alias: Id.

- `-ObjectId <guid>`
  The ID of the object to assign the app role to.

- `-AppRoleId <guid>`
  The ID of the app role to assign.

- `-PassThru <switch>`
  If specified, returns the app role assignment object.

## Examples

### Example 1: Add an app role assignment to a service principal
```powershell
Add-GraphServicePrincipalAppRoleAssignment -ServicePrincipalId "00000000-0000-0000-0000-000000000000" -ObjectId "00000000-0000-0000-0000-000000000000" -AppRoleId "00000000-0000-0000-0000-000000000000"
```

### Example 2: Add an app role assignment and return the assignment object
```powershell
Add-GraphServicePrincipalAppRoleAssignment -ServicePrincipalId "00000000-0000-0000-0000-000000000000" -ObjectId "00000000-0000-0000-0000-000000000000" -AppRoleId "00000000-0000-0000-0000-000000000000" -PassThru
```

---

*Disclaimer: This README was generated by Claude AI 3.5 Sonnet.*
