Function Add-GraphServicePrincipalAppRoleAssignment {
    <#
        .DESCRIPTION
        Adds an app role assignment to a service principal.

        .SYNOPSIS
        Adds an app role assignment to a service principal.
        
        .PARAMETER ServicePrincipalId
        The ID of the service principal to add the app role assignment to.

        .PARAMETER ObjectId
        The ID of the object to assign the app role to.

        .PARAMETER AppRoleId
        The ID of the app role to assign.

        .PARAMETER PassThru
        If specified, returns the app role assignment object.

        .EXAMPLE
        Add-GraphServicePrincipalAppRoleAssignment -ServicePrincipalId "00000000-0000-0000-0000-000000000000" -ObjectId "00000000-0000-0000-0000-000000000000" -AppRoleId "00000000-0000-0000-0000-000000000000"

        .INPUTS
        System.Guid
        System.Management.Automation.PSSwitchParameter

        .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(
            Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true
            
        )]
        [Alias('Id')]
        [guid]$ServicePrincipalId,
        [Parameter(Mandatory=$true)]
        [guid]$ObjectId,
        [Parameter(Mandatory=$true)]
        [guid]$AppRoleId,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    )
    Begin {
    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "POST"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals/$servicePrincipalId/appRoleAssignedTo"
        $invoke_mg_params["Body"] = @{}
        $invoke_mg_params["Body"]["principalId"] = $objectId
        $invoke_mg_params["Body"]["resourceId"] = $servicePrincipalId
        $invoke_mg_params["Body"]["appRoleId"] = $appRoleId
        $invoke_mg_params["OutputType"] = "PSObject"
        Try {
            $r = Invoke-MgGraphRequest @invoke_mg_params
        
        } Catch {
            Write-Error $_.Exception.Message -ErrorAction Stop

        }
    } End {
        If ($passThru) {
            $r
        
        }
    }
}