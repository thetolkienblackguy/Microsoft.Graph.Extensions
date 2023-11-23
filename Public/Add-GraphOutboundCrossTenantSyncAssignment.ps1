Function Add-GraphOutboundCrossTenantSyncAssignment {
    <#
        .DESCRIPTION
        This function adds an outbound cross-tenant sync user or group assignment to a service principal.

        .SYNOPSIS
        This function adds an outbound cross-tenant sync user or group assignment to a service principal.

        .PARAMETER ServicePrincipalId
        The service principal ID of the target tenant.

        .PARAMETER ObjectId
        The object ID of the user or group to add to the outbound cross-tenant sync assignment.

        .PARAMETER PassThru
        This parameter specifies whether to return the current settings after adding the outbound cross-tenant sync assignment. The default value is $false.

        .EXAMPLE
        Add-GraphOutboundCrossTenantSyncAssignment -ServicePrincipalId "00000000-0000-0000-0000-000000000000" -ObjectId "00000000-0000-0000-0000-000000000000" -PassThru

        .INPUTS
        System.String
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Object

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/22/2023
        Version: 0.0.1
        Name: Add-GraphOutboundCrossTenantSyncAssignment

        Version History:
        0.0.1 - Alpha Release - 11/22/2023 - Gabe Delaney 
    
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServicePrincipalId,
        [Parameter(Mandatory=$true)]
        [string]$ObjectId,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru

    )
    Begin {
        # Set the error action preference
        $ErrorActionPreference = "Stop"

        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Invoke-MgGraphRequest:OutputType"] = "PSObject"

        # Invoke-MgGraphRequest parameters for getting the app role
        $get_role_params = @{}
        $get_role_params["Method"] = "GET"
        $get_role_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$($servicePrincipalId)?`$select=appRoles"

        # Invoke-MgGraphRequest parameters for setting the app role
        $set_role_params = @{}
        $set_role_params["Method"] = "POST"
        $set_role_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$servicePrincipalId/appRoleAssignedTo"
        $set_role_params["Body"] = @{}
        $set_role_params["Body"]["principalId"] = $objectId
        $set_role_params["Body"]["resourceId"] = $servicePrincipalId
        
    } Process {
        Try {
            # Get the default access app role id
            $app_role = ((Invoke-MgGraphRequest @get_role_params).appRoles | Where-Object {
                $_.displayName -eq "msiam_access"
        
            }).id
            $set_role_params["Body"]["appRoleId"] = $app_role
        
            # Set the app role
            $r = Invoke-MgGraphRequest @set_role_params

        } Catch {
            # If the error is that the assignment already exists, return the current settings
            If ($_.ToString() -like "*Permission being assigned already exists on the object*") {
                Write-Warning "The assignment already exists on the service principal."
                Break
            
            } Else {
                Write-Error $_
                Break

            }
        } 
    } End {
        If ($passThru) {
            $r
        
        }
    }
}