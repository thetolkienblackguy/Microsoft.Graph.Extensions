Function Enable-GraphOutboundCrossTenantSync {
    <#


        .OUTPUTS
        System.Object

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/22/2023
        Version: 0.0.1
        Name: Enable-GraphOutboundCrossTenantSync

        Version History:
        0.0.1 - Alpha Release - 11/22/2023 - Gabe Delaney 
    
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId,
        [Parameter(Mandatory=$true)]
        [string]$ServicePrincipalId,
        [Parameter(Mandatory=$true)]
        [string]$ObjectId,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Group","User")]
        [string]$ObjectTypeName = "Group"#,
        #[Parameter(Mandatory=$false)]
        #[switch]$PassThru

    )
    Begin {
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
        # Get the default access app role id
        $app_role = ((Invoke-MgGraphRequest @get_role_params).appRoles | Where-Object {
            $_.displayName -eq "msiam_access"
    
        }).id
        $set_role_params["Body"]["appRoleId"] = $app_role
        
        # Set the app role
        $r = Invoke-MgGraphRequest @set_role_params

    } End {
        #If ($passThru) {
        #    $r
        
        #}
    }
}