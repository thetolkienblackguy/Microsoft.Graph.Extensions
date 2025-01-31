Function Enable-GraphUser {
    <#
        .DESCRIPTION
        This function enables a user in Microsoft Graph.

        .SYNOPSIS
        This function enables a user in Microsoft Graph.

        .PARAMETER UserId
        The user ID of the user to enable.

        .PARAMETER ApiVersion
        The API version to use. The default value is v1.0.

        .EXAMPLE
        Enable-GraphUser -UserId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphUser -Filter "UserPrincipalName eq 'john.doe@contoso.com'" | Enable-GraphUser -RevokeSessions

        .INPUTS
        System.String
        System.String[]
        System.Automation.SwitchParameter        

        .OUTPUTS
        System.Object

    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$true,Position=0,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
                
        )]
        [Alias(
            "Id","UserPrincipalName","UPN"
            
        )]
        [string[]]$UserId,
        [Parameter(Mandatory=$false)]
        [switch]$RevokeSessions,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
  
    )
    Begin {
        # Graph user endpoint
        $uri = "https://graph.microsoft.com/$apiVersion/users/{0}"
        
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "PATCH"
        $invoke_mg_params["Body"] = @{}
        $invoke_mg_params["Body"]["accountEnabled"] = $true
        
    } Process {
        Foreach ($id in $userId) {
            If ($PSCmdlet.ShouldProcess($id,"Enable user")) {
                Try {
                    # Enable user
                    Invoke-MgGraphRequest @invoke_mg_params -Uri ($uri -f $id)

                If ($passThru) {
                    Get-GraphUser -UserId $id

                    }
                } Catch {
                    # Write error
                    Write-Error -Message $_
                
                }
            }
        }
    } End {
        
    }
}